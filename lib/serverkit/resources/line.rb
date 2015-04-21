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
      attribute :state, default: DEFAULT_STATE, inclusion: %w[absent present], type: String

      # @note Override
      def apply
        if has_correct_file?
          send_applied_remote_file_content_to_path
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
          remote_file_content << line_with_break
        else
          (remote_file_content.each_line.to_a - [line_with_break]).join
        end
      end

      def has_correct_file?
        check_command_from_identifier(:check_file_is_file, path)
      end

      def has_correct_line?
        !(present? ^ remote_file_content.each_line.include?(line_with_break))
      end

      def line_with_break
        "#{line}\n"
      end

      def present?
        state == "present"
      end

      # @return [String]
      def remote_file_content
        run_command_from_identifier(:get_file_content, path).stdout
      end

      def send_applied_remote_file_content_to_path
        ::Tempfile.open("") do |file|
          file.write(applied_remote_file_content)
          file.close
          backend.send_file(file.path, path)
        end
      end
    end
  end
end
