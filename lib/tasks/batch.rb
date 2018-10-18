require 'active_support/time'
require 'net/https'
require 'uri'
require 'openssl'


class Tasks
  class Batch

  def self.execute
# 日次でチェックする内容 s
    # ・statusがuncompletedであること
    # ・registrated_dayからの経過日数が決まっている日数にあること
    d = Date.today;
    @transactions = Transaction.where(registration_date: (d-3).strftime("%Y-%m-%d")).where(status: "uncompleted")
# 日次でチェックする内容 e

    @transactions.each do |transaction|
      creditor_id = transaction.creditor_id.to_i
      @user = User.find_by(id: creditor_id)
      @name = transaction.debtor_name
      @company = Company.find_by(name: @name)
      @p_id = @company.id
      @chatworkid = Chatworkid.find_by(p_id: @p_id)
      @trid = @chatworkid.trid

# add message s
    uri = URI.parse("https://api.chatwork.com/v2/rooms/#{@trid}/messages")
    request = Net::HTTP::Post.new(uri)
    request["X-Chatworktoken"] = "ab68ec1c8c217d712b5a7859b14d36c3"
    request.set_form_data(
      "body" => "Kanekaesou_Appからのご連絡です。#{transaction.registration_date}に、#{transaction.goods}を、#{@user.name}さんから借りたままになっていませんか？",
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
  end

    # response.code
    # response.body
# add message e

  end

  # def self.frequent
  #   render("/")
  # end

  end
end
