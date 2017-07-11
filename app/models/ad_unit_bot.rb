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
    @account = account
    @email = account.email
    @password = account.password
    @session = Capybara::Session.new(:selenium)
  end


  def start_synchronization
    puts "Connecting with #{AdUnitBot::TARGET_URL}"
    begin
      connect_to_site
      @account.apps.each do |app|
        create_ad_block(app) if app_present?(app)
      end
      @session.driver.quit
    rescue RuntimeError => e
      puts e
      @session.driver.quit
    end
  end

  def connect_to_site
    @session.visit TARGET_URL
    DELAY.until { @session.has_xpath?(login_path) }
    @session.has_xpath?(login_path) ? login : (raise RuntimeError 'Connection error')
  end

  def login
    @session.find(:xpath, login_path).click

    @session.fill_in 'Email или телефон', with: @email
    @session.fill_in 'Пароль', with: @password

    @session.click_button('Sign in')
    raise 'Invalid login or password' unless login_successfull?
  end

  def login_successfull?
    DELAY.until { @session.has_xpath?(path_after_login) || @session.has_content?('Invalid login or password') }
    @session.has_xpath?(path_after_login)
  end

  def app_present?(app)
    DELAY.until { @session.has_link?(CREATE_PLATFORM) }
    begin
      puts app.inspect
      platform = @session.find(:xpath, "//a[contains(@href, '#{app.platform_id}')]")
    rescue Capybara::ElementNotFound
      puts platform.inspect
      raise 'Platform id is not found.'
    end
  end

  # def new_app
  #   @session.click_on('Заведите')      if @session.has_content?(WHERE_TO_BEGIN)
  #   @session.click_on(CREATE_PLATFORM) if @session.has_content?(CREATE_PLATFORM)
  #
  #   create_app
  # end

  # def create_app
  #   @session.click_on(CREATE_PLATFORM)
  #   DELAY.until { @session.has_content?('Ссылка на площадку') }
  #
  #   @session.fill_in 'Назовите вашу площадку', with: @app_name
  #   @session.fill_in 'Введите ссылку на площадку', with: @app_name
  #   DELAY.until { @session.has_content?('Рекламный блок') }
  #
  #   choose_block.click
  #   @session.find(:xpath, "//span[text()='#{CREATE_PLATFORM}']").click
  #   puts 'New app was successfully created.'
  # end

  def choose_platform(platform_id)
    @session.visit TARGET_URL
    DELAY.until { @session.has_link?(CREATE_PLATFORM) }

    platform = @session.find(:xpath, "//a[contains(@href, '#{platform_id}')]")
    platform.click
  end

  def create_ad_block(app)
    app.block_types.each do |type|
      choose_platform(app.platform_id)

      DELAY.until { @session.has_link?(CREATE_BLOCK) }
      @session.click_on(CREATE_BLOCK)
      begin
        DELAY.until { @session.has_content?('Типы блоков') }
      rescue RuntimeError, Capybara::ElementNotFound => e
        puts e
        @session.driver.quit
      end
      choose_block(type).click
      @session.find(:xpath, "//span[text()='Добавить блок']").click
      puts "#{type.capitalize} ad_unit for #{app.name} was successfully created."
    end
  end

  private

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
