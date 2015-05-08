require "serverkit/resources/base"
require "unix_crypt"

module Serverkit
  module Resources
    class User < Base
      attribute :gid, type: [Integer, String]
      attribute :home, type: String
      attribute :name, type: String, required: true
      attribute :password, type: String
      attribute :shell, type: String
      attribute :system, type: [FalseClass, TrueClass]
      attribute :uid, type: Integer

      # @note Override
      def apply
        if has_correct_user?
          update_user_encrypted_password unless has_correct_password?
          update_user_gid unless has_correct_gid?
          update_user_home_directory unless has_correct_home_directory?
          update_user_login_shell unless has_correct_login_shell?
          update_user_uid unless has_correct_uid?
        else
          add_user
        end
      end

      # @note Override
      def check
        case
        when !has_correct_user?
          false
        when !has_correct_gid?
          false
        when !has_correct_home_directory?
          false
        when !has_correct_password?
          false
        when !has_correct_login_shell?
          false
        when !has_correct_uid?
          false
        else
          true
        end
      end

      private

      def add_user
        run_command_from_identifier(
          :add_user,
          name,
          gid: gid,
          home_directory: home,
          password: encrypted_password,
          shell: shell,
          system_user: system,
          uid: uid,
        )
      end

      # @return [String, nil]
      def encrypted_password
        unless password.nil?
          @encrypted_password ||= UnixCrypt::SHA512.build(password)
        end
      end

      def get_remote_encrypted_password
        run_command_from_identifier(:get_user_encrypted_password, name).stdout
      end

      def has_correct_gid?
        gid.nil? || check_command_from_identifier(:check_user_belongs_to_group, name, gid)
      end

      def has_correct_home_directory?
        home.nil? || check_command_from_identifier(:check_user_has_home_directory, name, home)
      end

      def has_correct_login_shell?
        shell.nil? || check_command_from_identifier(:check_user_has_login_shell, name, shell)
      end

      def has_correct_password?
        password.nil? || ::UnixCrypt.valid?(password, get_remote_encrypted_password)
      end

      def has_correct_uid?
        uid.nil? || check_command_from_identifier(:check_user_has_uid, name, uid)
      end

      def has_correct_user?
        check_command_from_identifier(:check_user_exists, name)
      end

      def update_user_encrypted_password
        run_command_from_identifier(:update_user_encrypted_password, name, encrypted_password)
      end

      def update_user_gid
        run_command_from_identifier(:update_user_gid, name, gid)
      end

      def update_user_home_directory
        run_command_from_identifier(:update_user_home_directory, name, home)
      end

      def update_user_login_shell
        run_command_from_identifier(:update_user_login_shell, name, shell)
      end

      def update_user_uid
        run_command_from_identifier(:update_user_uid, name, uid)
      end
    end
  end
end
