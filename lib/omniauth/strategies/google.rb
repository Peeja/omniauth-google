require 'google/api_client'
require 'signet/oauth_2/client'
require 'multi_json'

module OmniAuth
  module Strategies
    ##
    # Authentication strategy for connecting with Google
    class Google
      include OmniAuth::Strategy

      PLUS_PROFILE_SCOPE = 'https://www.googleapis.com/auth/plus.me'
      USERINFO_SCOPE = 'https://www.googleapis.com/auth/userinfo.profile'
      DEFAULT_SCOPE = PLUS_PROFILE_SCOPE

      args [:client_id, :client_secret]

      option :client_options, {}
      option :client_id, nil
      option :client_secret, nil
      option :scope, DEFAULT_SCOPE
      option :refresh_token, nil
      option :api_key, nil

      def client
        @client ||= (begin
          client = ::Google::APIClient.new(options.client_options)
          client.key = options.api_key
          if request.ip != '127.0.0.1'
            client.user_ip = request.ip
          end
          if client.authorization.kind_of?(::Signet::OAuth2::Client)
            client.authorization.client_id = options.client_id
            client.authorization.client_secret = options.client_secret
            client.authorization.scope = options.scope
            client.authorization.refresh_token = options.refresh_token
            client.authorization.redirect_uri = redirect_uri
          end
          client
        end)
      end

      def redirect_uri
        full_host + script_name + callback_path
      end

      def profile_data
        if skip_info?
          raise ArgumentError,
            "Profile data is not available when the :skip_info option is set."
        end
        @profile_data ||= (begin
          if client.authorization.scope.include?(PLUS_PROFILE_SCOPE)
            plus = client.discovered_api('plus', 'v1')
            result = client.execute(plus.people.get, {'userId' => 'me'})
            result.data
          elsif client.authorization.scope.include?(USERINFO_SCOPE)
            result = client.execute(
              :uri => 'https://www.googleapis.com/oauth2/v1/userinfo'
            )
            result.data
          else
            raise ArgumentError,
              "Profile data is not available without requesting " +
              "the '#{USERINFO_SCOPE}' scope."
          end
        end)
      end

      uid do
        if client.authorization.id_token
          client.authorization.decoded_id_token['id']
        elsif client.authorization.access_token && !skip_info? &&
            (client.authorization.scope.include?(PLUS_PROFILE_SCOPE) ||
            client.authorization.scope.include?(USERINFO_SCOPE))
          # This is just relying on the fact that both profile formats store
          # the ID in the same field.
          profile_data.to_hash['id']
        elsif skip_info?
          raise ArgumentError,
            "ID token was missing and the :skip_info option was set, " +
            "preventing the use of an automatic API call fallback."
        else
          raise ArgumentError,
            "User ID is not available without requesting " +
            "the '#{USERINFO_SCOPE}' scope."
        end
      end

      info do
        prune!(profile_data.to_hash)
      end

      credentials do
        hash = {'token' => client.authorization.access_token}
        if client.authorization.refresh_token
          hash.merge!('refresh_token' => client.authorization.refresh_token)
        end
        if client.authorization.id_token
          hash.merge!('id_token' => client.authorization.id_token)
          # TODO(bobaman): This should maybe attempt to verify the ID token.
          hash.merge!(
            'decoded_id_token' => client.authorization.decoded_id_token
          )
        end
        # Token expiration data should not be relied upon. Only the
        # error for invalid_credentials can be trusted.
        if client.authorization.expires_in
          hash.merge!('expires_in' => client.authorization.expires_in)
        end
        if client.authorization.issued_at
          hash.merge!('issued_at' => client.authorization.issued_at)
        end
        prune!(hash)
      end

      extra do
        prune!({
          'profile' => (!skip_info? ? profile_data : nil),
          'client' => client
        })
      end

      def request_phase
        redirect client.authorization.authorization_uri.to_s
      end

      def callback_phase
        if request.params['error'] || request.params['error_reason']
          raise CallbackError.new(
            request.params['error'],
            request.params['error_description'] ||
              request.params['error_reason'],
            request.params['error_uri']
          )
        end
        if request.params['code']
          client.authorization.code = request.params['code']
        end
        client.authorization.fetch_access_token!
        super
      rescue ::Signet::UnsafeOperationError => e
        fail!(:unsafe_operation, e)
      rescue ::Signet::AuthorizationError, CallbackError => e
        fail!(:invalid_credentials, e)
      rescue ::MultiJson::DecodeError, ::Signet::ParseError => e
        fail!(:invalid_response, e)
      rescue ::Timeout::Error, ::Errno::ETIMEDOUT => e
        fail!(:timeout, e)
      end

    protected
      # An error that is indicated in the OAuth 2.0 callback.
      # This could be a `redirect_uri_mismatch` or other
      class CallbackError < StandardError
        attr_accessor :error, :error_reason, :error_uri

        def initialize(error, error_reason=nil, error_uri=nil)
          self.error = error
          self.error_reason = error_reason
          self.error_uri = error_uri
        end
      end
    private
      def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end
    end
  end
end
