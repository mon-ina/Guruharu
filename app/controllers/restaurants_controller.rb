class RestaurantsController < ApplicationController
  require 'pp'
  require 'json'

 def index
  # セッションに保存（フォームから送られてきたときのみ更新）
  session[:lat]     = params[:lat] if params[:lat]
  session[:lng]     = params[:lng] if params[:lng]
  session[:range]   = params[:range] if params[:range]
  session[:budget_group]  = params[:budget_group] if params[:budget_group]
  session[:genre]   = params[:genre] if params[:genre]
  session[:open]    = params[:open] if params[:open]

  # セッションから検索条件を取り出し
  @latitude   = params[:lat] || session[:lat]
  @longitude  = params[:lng] || session[:lng]
  @range      = params[:range] || session[:range] || 3
  @keyword    = params[:keyword]
  @budget_group = params[:budget_group] || session[:budget_group]
  @genre      = params[:genre] || session[:genre]
  @open       = params[:open] || session[:open]
  @page       = params[:page].to_i
  @page = 1 if @page < 1 #ページ番号が指定されていない場合や1未満なら、ページ番号を1に設定。

  per_page = 20
  start = (@page - 1) * per_page + 1

  # 「2000円〜」の選択肢に対応
  budget_codes = case @budget_group
  when "over_2000"
    ["B002", "B003", "B004", "B005", "B006", "B008"] # 2000円超えのコード
  when ""
    nil
  else
    [@budget_group]
  end

  # 配列をカンマ区切りに変換
  budget_param = budget_codes&.join(",")

  if @latitude.present? && @longitude.present?
    query = {
      key: ENV['HOTPEPPER_API_KEY'],
      lat: @latitude,
      lng: @longitude,
      range: @range,
      keyword: @keyword,
      genre: @genre,
      open: @open == "1" ? "now" : nil,
      budget: budget_param,
      format: 'json',
      count: per_page,
      start: start
    }.compact

    response = HTTParty.get("http://webservice.recruit.co.jp/hotpepper/gourmet/v1/", query: query)

    parsed = JSON.parse(response.parsed_response)
    results = parsed["results"]
    shops = results["shop"]
    @total_results_available = results["results_available"].to_i
    @total_pages = (@total_results_available / per_page.to_f).ceil
    @shops = shops || []
    else
      @shops = []
      @total_pages = 0
    end
>>>>>>> show-style
end



  def show
  shop_id = params[:id]

  response = HTTParty.get("http://webservice.recruit.co.jp/hotpepper/gourmet/v1/", {
    query: {
      key: ENV['HOTPEPPER_API_KEY'],
      id: shop_id,
      format: 'json'
    }
  })

  json_str = response.parsed_response
  parsed = JSON.parse(json_str)  # エスケープされた文字列をデコード
  results = parsed["results"] 
  shop_data = results["shop"] 
  @shop = shop_data.first
  end

end

<<<<<<< HEAD
>>>>>>> search-style
=======
>>>>>>> show-style
