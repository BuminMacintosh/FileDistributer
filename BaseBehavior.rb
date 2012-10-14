#coding:utf-8

require "fileutils"			# ファイルコピー用ライブラリ

# plugin module
# 振り分け対象となるファイルや、移動先の追加パスを作成する
class BaseBehavior

	# 振り分け処理
	def distribute(file, path)

		# 対象ファイルの年月で振り分ける
		dateFormat = File::mtime(file).strftime("/%Y/%m")

		# コピー先ディレクトリ作成
		checkPath = path
		dateFormat.split("/").each do | parts |
			checkPath += "/" + parts
			unless FileTest.directory?(checkPath)
				Dir::mkdir(checkPath)
			end
		end

		destinationPath = path + dateFormat + "/" + File::basename(file)
		print "\t" + file + " --> " + destinationPath + "\n"

		# ファイルコピー
		begin
			FileUtils.cp(file, destinationPath)
		rescue
			print "\tファイルコピーに失敗しました。\n"
			exit!
		end
	end
end
