#coding:utf-8

require "./BaseBehavior"

# plugin module
# 振り分け対象となるファイルや、移動先の追加パスを作成する
class AviBehavior < BaseBehavior
	# 振り分け対象は拡張子がAVIのものだけとする
	def initialize()
		@extention = "AVI"
	end

	# 振り分け処理
	def distribute(file, path)
		if File::extname(file).split(".")[1] != @extention
			return
		end

		super(file, path)
	end
end
