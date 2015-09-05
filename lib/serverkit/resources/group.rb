require "serverkit/resources/base"

module Serverkit
  module Resources
    class Group < Base
      attribute :gid, type: Integer
      attribute :name, required: true, type: String

      # @note Override
      def apply
        if has_correct_group?
          run_command_from_identifier(:update_group_gid, name, gid)
        else
          run_command_from_identifier(:add_group, name, gid: gid)
        end
      end

      # @note Override
      def check
        has_correct_group? && has_correct_gid?
      end

      private

      def has_correct_gid?
        gid.nil? || gid == remote_gid
      end

      def has_correct_group?
        check_command_from_identifier(:check_group_exists, name)
      end

      # @return [Integer]
      def remote_gid
        run_command_from_identifier(:get_group_gid, name).stdout.strip.to_i
      end
    end
  end
end
