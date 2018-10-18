require 'pry'

class UsersController < ApplicationController

  before_action :authenticate_user, {only:[:show,:edit,:update]}
  before_action :forbid_login_user, {only:[:new,:create,:login_form,:login]}

  def new
# 新規ユーザー登録画面の表示
  end

  def create
# 新規ユーザー情報のDB登録
     @user = User.new(
       name: params[:name],
       email: params[:email],
       password: params[:password]
     )
     if @user.save
       session[:user_id] = @user.id
       flash[:notice] = "signed in!"
       redirect_to("/users/#{@user.id}")
     else
       render("users/new")
     end
  end

  def login_form
# ログイン画面の表示
  end

  def login
# ログイン
    @user = User.find_by(email: params[:email], password: params[:password])
    if @user
      session[:user_id] = @user.id
      flash[:notice] = "logged in!"
      redirect_to("/users/#{@user.id}")
    else
      flash[:notice] = "try again"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  def logout
# ログアウト
     session[:user_id] = nil
     flash[:notice] = "logged out"
     redirect_to("/login")
  end

  def show
    # binding.pry
    # マイページの表示
    @user = User.find_by(id: params[:id])
    
    if  @user == nil || @user.id != @current_user.id
       return redirect_to("/")
    end
    # # @transactions = Transaction.all
    @transactions = Transaction.where(creditor_id: params[:id])

    if @names.blank?
      @names = [" ", " "]
    end
    # redirect_to("/users/#{@user.id}")
  end


  def edit
# ユーザー情報変更画面の表示
  end

  def update
# ユーザー情報のDB変更アクション/put off.
# やるならこれも（https://prog-8.com/rails5/study/8/14#/47）
  end

end
