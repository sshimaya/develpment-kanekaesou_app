require 'pry'
require 'net/https'
require 'json'
require 'uri'
require 'openssl'
require 'time'
# require 'faraday'

class TransactionsController < ApplicationController

  before_action :authenticate_user

  def new
# 取引登録画面の表示
  end

  # @transaction = Transaction.find_by(id: params[:id])
  # creditor_id = @transaction.creditor_id.to_i
  # @user = User.find_by(id: creditor_id)

  def search
    @user = User.find_by(id: params[:id])

    @nicknames = Nickname.where(nick: params[:nickname])
    # binding.pry
    @p_ids = @nicknames.pluck(:p_id)
    @companies = Company.where(id: @p_ids)
    @names = @companies.pluck(:name)

    @transactions = Transaction.where(creditor_id: params[:id])
    # redirect_to("/users/#{@user.id}")
    # render template: "users/#{@user.id}/show"
    # render :controller => "users", :action => "show", :id => @user.id
    render :action => "../users/show"
  end

  def create
    # 取引情報のDB登録
    @user = User.find_by(id: params[:id])

    @transaction = Transaction.new(
# user_id?creditor_id?
       creditor_id: @user.id,
       debtor_name: params[:debtor_name],
       goods: params[:goods],
       registration_date: params[:registration_date],
       status: "uncompleted"
     )
     if @transaction.save
       flash[:notice] = "registration completed!"
       redirect_to("/users/#{@user.id}")
     else
# kokodounaruka
       render("users/#{@user.id}")
     end
  end

  # def up
  # end

  def show
# 取引の詳細表示
    @transaction = Transaction.find_by(id: params[:id])

  end

  def remind
    @transaction = Transaction.find_by(id: params[:id])
    creditor_id = @transaction.creditor_id.to_i
    @user = User.find_by(id: creditor_id)
# Debtorのtridを取得しないといけない
    @name = @transaction.debtor_name
    @company = Company.find_by(name: @name)
    @p_id = @company.id
    # binding.pry
    @chatworkid = Chatworkid.find_by(p_id: @p_id)
    @trid = @chatworkid.trid
# add message s
    uri = URI.parse("https://api.chatwork.com/v2/rooms/#{@trid}/messages")
    request = Net::HTTP::Post.new(uri)
    request["X-Chatworktoken"] = "ab68ec1c8c217d712b5a7859b14d36c3"
    request.set_form_data(
      "body" => "Kanekaesou_Appからのご連絡です。#{@transaction.registration_date}に、#{@transaction.goods}を、#{@user.name}さんから借りたままになっていませんか？",
      # "body" => "Kanekaesou_Appからのご連絡です。"&@transaction.registration_date&"に、"&@transaction.goods&"を、"&@user.name&"さんから借りたままになっていませんか？",
      "self_unread" => "0",
    )

    req_options = {
      use_ssl: uri.scheme == "https",
      verify_mode: OpenSSL::SSL::VERIFY_NONE,
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    # response.code
    # response.body
# ass message e

# add task s
  # タスク期限日を設定しないといけない、これは記述方法と何日後家の設定が必要
  # due_date = now.since(3.days)
  # Time.parse(due_date).to_i
    # # uri = URI.parse("https://api.chatwork.com/v2/rooms/125684423/tasks")
    # request = Net::HTTP::Post.new(uri)
    # request["X-Chatworktoken"] = "ab68ec1c8c217d712b5a7859b14d36c3"
    # request.set_form_data(
    #   "body" => "test",
    #   "limit" => "1539323377",
    #   "to_ids" => "3163412",
    # )
    #
    # req_options = {
    #   use_ssl: uri.scheme == "https",
    #   verify_mode: OpenSSL::SSL::VERIFY_NONE,
    # }
    #
    # response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    #   http.request(request)
    #
    # end
# add task e

#create tr s(コンタクトを追加されている＝TRある前提になるので、いったん不要)
    # uri = URI.parse("https://api.chatwork.com/v2/rooms")
    # request = Net::HTTP::Post.new(uri)
    # request["X-Chatworktoken"] = "ab68ec1c8c217d712b5a7859b14d36c3"
    # request.set_form_data(
    #   "description" => "Remind from Kanekaesou_App",
    #   "icon_preset" => "check",
    #   "members_admin_ids" => "3163412",
    #   "members_member_ids" => @,
    #   "name" => "Remind from Kanekaesou_App",
    # )
    #
    # req_options = {
    #   use_ssl: uri.scheme == "https",
    #   verify_mode: OpenSSL::SSL::VERIFY_NONE,
    # }
    #
    # response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    #   http.request(request)
    # end
#create tr e

    flash[:notice] = "Done!"
    redirect_to("/users/#{@user.id}")
  end

  def destroy
# ここだいじ！
    @transaction = Transaction.find_by(id: params[:id])
    @transaction.status = "completed"
    @transaction.save
    flash[:notice] = "Done!"
    redirect_to("/users/#{@transaction.creditor_id}")
    # render :action => "../users/show"

  end

end
