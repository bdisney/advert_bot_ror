require 'selenium-webdriver'
require 'capybara'
require 'capybara/dsl'

Capybara.run_server = false
Capybara.current_driver = :selenium

class AdUnitBot < ApplicationRecord
  include Capybara::DSL

  TARGET_URL      = 'https://target-sandbox.my.com'.freeze
  DELAY           = Selenium::WebDriver::Wait.new(timeout: 50)
  WHERE_TO_BEGIN  = 'С чего начать?'.freeze
  CREATE_PLATFORM = 'Создать площадку'.freeze
  CREATE_BLOCK    = 'Создать блок'.freeze

  def initialize(account)
    @account   = account
    @email     = account.email
    @password  = account.password
    @session   = Capybara::Session.new(:selenium)
    @logger    = Logger.new("#{Rails.root}/log/#{account.email}.log")
  end

  def start_synchronization
    begin
      connect_to_site
      @account.apps.each { |app| create_ad_block(app) if app_present?(app) }

      @account.synhronized!
      @session.driver.quit
      @logger.info '***** Session closed. *****'
    rescue RuntimeError, Capybara::ElementNotFound => e
      @logger.error e.message
      # e.backtrace.each { |line| @logger.error line }

      @account.failed!
      @session.driver.quit
      @logger.info '***** Session closed. *****'
    end
  end

  private

  def connect_to_site
    @account.in_progress!
    @logger.info "Connecting with #{AdUnitBot::TARGET_URL}"
    @session.visit TARGET_URL
    DELAY.until { @session.has_xpath?(login_path) }
    @session.has_xpath?(login_path) ? login : (raise RuntimeError 'Connection error')
  end

  def login
    @session.find(:xpath, login_path).click

    @session.fill_in 'Email или телефон', with: @email
    @session.fill_in 'Пароль', with: @password

    @session.click_button('Войти')
    raise 'Invalid login or password' unless login_successfull?
    @logger.info 'Loggined in successfully.'
  end

  def login_successfull?
    DELAY.until { @session.has_xpath?(path_after_login) || @session.has_content?('Invalid login or password') }
    @session.has_xpath?(path_after_login)
  end

  def app_present?(app)
    @session.visit TARGET_URL
    DELAY.until { @session.has_link?(CREATE_PLATFORM) }
    platform = @session.find(:xpath, "//a[contains(@href, '#{app.platform_id}')]")
    raise 'Platform id is not present.' unless platform.present?
    true
  end

  def create_ad_block(app)
    app.block_types.each do |type|
      @logger.info "Trying create #{type} ad_unit for #{app.name} app."
      choose_platform(app.platform_id)

      DELAY.until { @session.has_link?(CREATE_BLOCK) }
      @session.click_on(CREATE_BLOCK)
      begin
        DELAY.until { @session.has_content?('Типы блоков') }
      rescue RuntimeError, Capybara::ElementNotFound => e
        @logger.error e.message
        @account.failed!
        @session.driver.quit
      end
      choose_block(type).click
      @session.find(:xpath, "//span[text()='Добавить блок']").click
      @logger.info "#{type.capitalize} ad_unit for #{app.name} was successfully created."
    end
  end

  def choose_platform(platform_id)
    @session.visit TARGET_URL
    DELAY.until { @session.has_link?(CREATE_PLATFORM) }

    platform = @session.find(:xpath, "//a[contains(@href, '#{platform_id}')]")
    platform.click
    @logger.info "Found platform with id: #{platform_id}"
  end

  def choose_block(type)
    if @session.has_content?('Формат размещения больше вам недоступен')
      @session.driver.quit
      raise 'Placement format is no longer available'
    else
      @session.find(:xpath, "//span[text()='#{type}']")
    end
  end

  def login_path
    "//span[text()='Войти']"
  end

  def path_after_login
    "//span[text()='#{@email}']"
  end
end
