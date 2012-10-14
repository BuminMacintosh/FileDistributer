#coding:utf-8

require "rexml/document"	# XML用ライブラリ

# FileDistributerの設定情報を管理する
class FileDistributerConfig
	# config ファイルを指定して初期化する
	def initialize(configFileName)
		# defaultのファイル名は "./FileDistributer.config"
		if nil == configFileName
			configFileName = "./FileDistributer.config"
		end

		File.open(configFileName) do | itr |
			@xmlConfig = REXML::Document.new(itr)
		end

		@plugin = Array.new()

		# xml要素からInputPath、OutputPath、Plugin情報を分離する
		@xmlConfig.root.elements.each do | e |
			case e.name
			when "inputPath"
				@inputPath = e.text
			when "outputPath"
				@outputPath = e.text
			when "plugin"
				@plugin.push(e.text)
			end
		end
	end

	# 各種アクセサ
	def inputPath() @inputPath end
	def outputPath() @outputPath end
	def plugin() @plugin end
end


# コピー元となるファイルの収集クラス
class FileGather
	# ターゲットディレクトリを指定して初期化する
	def initialize(parentPath)
		# サブディレクトリを含む対象ファイルのパスをリスト化
		targetDir = parentPath + "/**/*.*"
		@pathList = Dir::glob(targetDir)
	end

	# 収集したパスに基づくファイルオブジェクトリストを返す
	def getFiles()
		@pathList.each do | path |
			Dir::foreach(path)
		end
	end
end


# main
# File Distributer の実行部分
begin
	# Config読込
	config = FileDistributerConfig.new(ARGV[0])

	# 外部モジュールのロード
	config.plugin.each do | plugin |
		load plugin

		# Distributer behavior 生成
		begin
			behavior = eval(plugin.split(".")[0] + ".new()")
		rescue
			print "指定されたビヘイビアが生成できませんでした。"
			exit!
		end

		# リストアップされたパスにあるファイルごとに振り分ける
		FileGather.new(config.inputPath).getFiles.each do | file |
			behavior.distribute(file, config.outputPath)
		end
	end
end

