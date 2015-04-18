require "serverkit/resources/base"

module Serverkit
  module Resources
    class User < Base
      attribute :gid, type: [Integer, String]
      attribute :home_directory, type: String
      attribute :name, type: String, required: true
      attribute :password, type: String
      attribute :system_user, type: [FalseClass, TrueClass]
      attribute :uid, type: Integer

      # @note Override
      def apply
        case
        when !has_correct_user?
          run_command_from_identifier(
            :add_user,
            name,
            gid: gid,
            home_directory: home_directory,
            password: password,
            system_user: system_user,
            uid: uid,
          )
        when !has_correct_gid?
          run_command_from_identifier(:update_user_gid, name, gid)
        when !has_correct_uid?
          run_command_from_identifier(:update_user_uid, name, uid)
        when !has_correct_home_directory?
          run_command_from_identifier(:update_user_home_directory, name, home_directory)
        end
      end

      # @todo Check password
      # @note Override
      def check
        case
        when !has_correct_user?
          false
        when gid && !has_correct_gid?
          false
        when uid && !has_correct_uid?
          false
        when home_directory && !has_correct_home_directory?
          false
        else
          true
        end
      end

      private

      def has_correct_gid?
        check_command_from_identifier(:check_user_belongs_to_group, name, gid)
      end

      def has_correct_home_directory?
        check_command_from_identifier(:check_user_has_correct_home_directory, name, home_directory)
      end

      def has_correct_uid?
        check_command_from_identifier(:check_user_has_uid, name, uid)
      end

      def has_correct_user?
        check_command_from_identifier(:check_user_exists, name)
      end
    end
  end
end
