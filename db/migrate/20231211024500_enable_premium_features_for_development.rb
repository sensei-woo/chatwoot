class EnablePremiumFeaturesForDevelopment < ActiveRecord::Migration[7.0]
  def up
    # Set installation plan to enterprise
    InstallationConfig.find_or_create_by(name: 'INSTALLATION_PRICING_PLAN').update(value: 'enterprise')
    
    # Enable all features by default including premium ones
    features = YAML.safe_load(Rails.root.join('config/features.yml').read)
    feature_names = features.map { |f| f['name'] }
    
    # Create default feature config
    InstallationConfig.find_or_create_by(name: 'ACCOUNT_LEVEL_FEATURE_DEFAULTS').update(
      value: feature_names.map { |name| { name: name, enabled: true } }
    )
  end

  def down
    # Reset installation plan to community
    InstallationConfig.find_or_create_by(name: 'INSTALLATION_PRICING_PLAN').update(value: 'community')
    
    # Remove default feature config
    InstallationConfig.find_by(name: 'ACCOUNT_LEVEL_FEATURE_DEFAULTS')&.destroy
  end
end
