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
      attribute :line, required: true, type: String
      attribute :pattern, type: String
      attribute :state, default: DEFAULT_STATE, inclusion: %w[absent present], type: String

      # @note Override
      def apply
        if has_correct_file?
          update_remote_file_content(
            content: applied_remote_file_content,
            path: path,
          )
        end
      end

      # @note Override
      def check
        has_correct_file? && has_correct_line?
      end

      private

      # @return [String]
      def applied_remote_file_content
        if present?
          content.append(line).to_s
        else
          content.delete(line).to_s
        end
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
        content.match(regexp || line)
      end

      def line_with_break
        "#{line}\n"
      end

      def present?
        state == "present"
      end

      # @return [Regexp, nil]
      def regexp
        if pattern
          ::Regexp.new(pattern)
        end
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
          string = @raw
          string += "\n" unless @raw.end_with?("\n")
          self.class.new(string + line + "\n")
        end

        # @param [String] line
        # @return [Serverkit::Resources::Line::Content]
        def delete(line)
          self.class.new(@raw.gsub(/^#{line}$/, ""))
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

        # @return [Array<String>]
        def lines
          @lines ||= @raw.each_line.map do |line|
            line.gsub(/\n$/, "")
          end
        end
      end
    end
  end
end
