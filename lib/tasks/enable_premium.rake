namespace :premium do
  desc 'Enable premium features for development'
  task enable: :environment do
    # Set installation plan to enterprise
    InstallationConfig.find_or_create_by(name: 'INSTALLATION_PRICING_PLAN')
                     .update(value: 'enterprise')

    # Get premium features from the helper
    premium_features = %w[
      custom_roles
      audit_logs
      sla
      help_center_embedding_search
      response_bot
    ]

    # Enable premium features for all accounts
    Account.find_each do |account|
      puts "Enabling premium features for account: #{account.id}"
      account.enable_features!(*premium_features)
    end

    puts 'Premium features enabled successfully!'
  end
end
