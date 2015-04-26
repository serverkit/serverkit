require "serverkit/resources/base"

module Serverkit
  module Resources
    # Ensure a particular line is in a file, or replace an existing line using regexp.
    # @example Example line resource that ensures a line is in /etc/sudoers
    #   - type: line
    #     path: /etc/sudoers
    #     line: "#includedir /etc/sudoers.d"
    class Line < Base
      DEFAULT_STATE = "present"

      attribute :path, required: true, type: String
      attribute :insert_after, type: String
      attribute :insert_before, type: String
      attribute :line, required: true, type: String
      attribute :pattern, regexp: true, type: String
      attribute :state, default: DEFAULT_STATE, inclusion: %w[absent present], type: String
      attribute :validation_script, type: String

      # @note Override
      def apply
        if has_correct_file?
          if validation_script
            update_remote_file_content_with_validation
          else
            update_remote_file_content_without_validation
          end
        end
      end

      # @note Override
      def check
        has_correct_file? && has_correct_line?
      end

      private

      def absent?
        state == "absent"
      end

      # @return [String]
      def applied_remote_file_content
        case
        when absent?
          content.delete(line)
        when insert_after
          content.insert_after(Regexp.new(insert_after), line)
        when insert_before
          content.insert_before(Regexp.new(insert_before), line)
        else
          content.append(line)
        end.to_s
      end

      # @return [Serverkit::Resources::Line::Content]
      def content
        Content.new(get_remote_file_content)
      end

      # @return [String]
      def get_remote_file_content
        run_command_from_identifier(:get_file_content, path).stdout
      end

      def has_correct_file?
        check_command_from_identifier(:check_file_is_file, path)
      end

      def has_correct_line?
        case
        when present? && !has_matched_line?
          false
        when !present? && has_matched_line?
          false
        else
          true
        end
      end

      def has_matched_line?
        if pattern
          content.match(Regexp.new(pattern))
        else
          content.match(line)
        end
      end

      def present?
        state == "present"
      end

      # Create a new temp file on remote side, then validate it with given script,
      # and move it to right file path if it succeeded. Note that `%{path}` in validation
      # script will be replaced with the path to temp file.
      def update_remote_file_content_with_validation
        temp_path = create_remote_temp_file(applied_remote_file_content)
        if check_command(format(validation_script, path: temp_path))
          move_remote_file_keeping_destination_metadata(temp_path, path)
        end
        run_command_from_identifier(:remove_file, temp_path)
      end

      # Create or update remote file
      def update_remote_file_content_without_validation
        update_remote_file_content(content: applied_remote_file_content, path: path)
      end

      # Wrapper class to easily manage lines in remote file content.
      class Content
        # @param [String] raw
        def initialize(raw)
          @raw = raw
        end

        # @param [String] line
        # @return [Serverkit::Resources::Line::Content]
        def append(line)
          self.class.new([*lines, line, ""].join("\n"))
        end

        # @param [String] line
        # @return [Serverkit::Resources::Line::Content]
        def delete(line)
          self.class.new(@raw.gsub(/^#{Regexp.escape(line)}[\n$]/, ""))
        end

        # Insert the line after the last matched line or EOF
        # @param [Regexp] regexp
        # @param [String] line
        # @return [Serverkit::Resources::Line::Content]
        def insert_after(regexp, line)
          if index = lines.rindex { |line| line =~ regexp }
            insert(index + 1, line)
          else
            append(line)
          end
        end

        # Insert the line before the last matched line or BOF
        # @param [Regexp] regexp
        # @param [String] line
        # @return [Serverkit::Resources::Line::Content]
        def insert_before(regexp, line)
          if index = lines.rindex { |line| line =~ regexp }
            insert(index, line)
          else
            prepend(line)
          end
        end

        # @param [Regexp, String] pattern
        # @return [false, true] True if any line matches given pattern
        def match(pattern)
          lines.lazy.grep(pattern).any?
        end

        # @note Override
        def to_s
          @raw.dup
        end

        private

        # @param [Integer] index
        # @param [String] line
        # @return [Serverkit::Resources::Line::Content]
        def insert(index, line)
          self.class.new([*lines.dup.insert(index, line), ""].join("\n"))
        end

        # @return [Array<String>]
        def lines
          @lines ||= @raw.each_line.map do |line|
            line.gsub(/\n$/, "")
          end
        end

        # @param [String] line
        # @return [Serverkit::Resources::Line::Content]
        def prepend(line)
          self.class.new("#{line}\n#{@raw}")
        end
      end
    end
  end
end
