class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy, :synchronize]

  def index
    @accounts = Account.all
  end

  def show
  end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      redirect_to @account, notice: 'Account was created'
    else
      render :new
    end
  end

  def update
    if @account.update(account_params)
      redirect_to accounts_path, notice: 'Account was updated.'
    else
      render :edit
    end
  end

  def synchronize
    @account.synhronize
  end

  def destroy
    @account.destroy
    redirect_to accounts_path, notice: 'Account was destroyed.'
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:email, :password, app_ids: [])
  end
end