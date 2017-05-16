require "nkrb/version"
require "open-uri"
require 'faraday'
require 'nokogiri'

module Nkrb
  module_function
  # file 読み込み
  ## 概要
  # ファイルを一行づつ読み込み, 一行を 1 つの要素とした配列を返す
  ## 引数
  # filename:  ファイル名
  # delimiter: 区切り文字
  ## 仕様
  # 1. filename が nil または空文字の場合は nil を返す
  # 2. その他処理の途中でエラーが起これば nil を返す
  # 3. 一行をある区切り文字で split して欲しい場合は delimiter で
  #    その区切り文字を指定する
  # 4. delimiter に指定がなければ (delimiter が nil) 一行をそのまま返す
  # 5. 末尾にある改行コードは削除する
  def read_file(filename, delimiter: nil)
    is_invalid_filename = filename.nil? || filename == ''
    return nil if is_invalid_filename

    begin
      lines = []
      File.open(filename) do |f|
        f.each_line do |line|

          line = delimiter.nil? ? 
                 line.chomp : 
                 line.chomp.split(delimiter)
          lines.push(line)
        end
      end
      lines
    rescue
      #p "Error has occured. Unread file."
      #p "filename: #{filename}"
      nil
    end
  end

  # tsv 読み込み
  ## 概要
  # tsv ファイルを読み込み, 一行目の文字列を key とした collection を返す
  ## 引数
  # filename:  ファイル名
  ## 仕様
  # 1. filename が nil または空文字の場合は nil を返す
  # 2. その他処理の途中でエラーが起これば nil を返す
  # 3. collection の key となるのは一行目の文字列を \t で split した文字列群である
  # 4. 末尾にある改行コードは削除する
  def read_tsv(filename, delimiter: "\t")
    tsv_data = read_file(filename, delimiter: delimiter)
    return nil if tsv_data.nil?
    
    begin
      headers    = tsv_data.shift
      collection = []

      tsv_data.each do |data|
        obj = {}
        headers.each_with_index do |header, i|
          obj[header] = data[i]
        end
        collection.push obj
      end
      collection
    rescue
      #p "Cannot convert to collection!"
      nil
    end
  end

  # pluck
  ## 概要
  # コレクションからあるキーの値を抽出し, 配列として返す
  ## 引数
  # collection: pluck 対象のコレクション
  # key:        pluck するキー名
  ## 仕様
  # 1. 引数の collection が配列でなければ nil を返す
  # 2. 引数の key が nil であれば nil を返す
  # 3. その他処理の途中でエラーが起これば nil を返す
  def pluck(collection, key:)
    return nil if key.nil? || collection.class != Array

    begin
      collection.map do |element|
        element[key]
      end
    rescue
      p "Cannot pluck."
      nil
    end
  end

  # 画像のダウンロード
  ## 概要
  # 特定の URL の画像をダウンロードする
  ## 引数
  # url: ダウンロードする画像の URL
  # dir: ダウンロード先の dir
  # filename: ダウンロード後の filename
  def download_image(url, dir, filename = nil)
    extention = url.split(".").last
    filename = filename.to_s + "." + extention || File.basename(url)
    begin
      open(dir + filename, 'wb+') do |output|
        open(url) do |data|
          output.write(data.read)
        end
      end
    rescue => e
      nil
    end
  end

  def faraday_connection(url, logger=false)
    Faraday.new(:url => url) do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger if logger
      faraday.adapter  Faraday.default_adapter
    end
  end

  def nokogiri(url, charset='utf-8')
    Nokogiri::HTML.parse(open(url), nil, charset)
  end

  def random_str(len=5)
    o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
    (0...len).map { o[rand(o.length)] }.join
  end
end
