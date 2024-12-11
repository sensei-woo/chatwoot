# Only enable premium features in development mode
if Rails.env.development?
  Rails.application.config.after_initialize do
    # Set installation plan to enterprise
    InstallationConfig.find_or_create_by(name: 'INSTALLATION_PRICING_PLAN')
                     .update(value: 'enterprise')

    # Enable premium features for all accounts
    premium_features = %w[
      custom_roles
      audit_logs
      sla
      help_center_embedding_search
      response_bot
    ]

    Account.find_each do |account|
      Rails.logger.info "Enabling premium features for account: #{account.id}"
      account.enable_features!(*premium_features)
    end

    Rails.logger.info 'Premium features enabled automatically in development mode'
  end
end
