if (!require(duckdb)) install.packages("duckdb")
# インメモリデータベースに接続
#con <- dbConnect(duckdb())

# データベースに接続
# (DBを他のプロセスと共有するときは、read_only = TRUEにし書き込みを禁止する。)
con <- dbConnect(duckdb(), dbdir = 'a.duckdb', read_only = FALSE)

# データベースにあるテーブルを表示
dbListTables(con)

#ニューヨークの飛行場データを用いて，出発地（origin）ごとに，目的地（dest）別のフライト数をカウント，上位3つの出発地（アルファベット順），および目的地を表示する。
if (!require(tidyverse)) install.packages("tidyverse")
con <- dbConnect(duckdb()) # インメモリデータベースを作成、接続
duckdb_register(con, "flights", flights) # filightsを紐付け（DuckDBのテーブルとして扱う）

# DuckDBライブラリの機能でクエリを表示（show_query）できる。
#tbl(con, 'flights') |> group_by(origin) |> count(dest) |> slice_max(n, n = 3) |> arrange(origin) |> show_query()
tbl(con, 'flights') |> 
  group_by(origin) |> 
  count(dest) |>
  slice_max(n, n = 3) |> #上位3つを取り出す
  arrange(origin) -> res

print(res) # 結果表示


#演習課題
library(tidyverse)

d <- data.frame(
  name = c("太郎", "花子", "三郎", "良子", "次郎", "桜子", "四郎", "松子", "愛子"),
  school = c("南", "南", "南", "南", "南", "東", "東", "東", "東"),
  teacher = c("竹田", "竹田", "竹田", "竹田",  "佐藤", "佐藤", "佐藤", "鈴木", "鈴木"),
  gender = c("男", "女", "男", "女", "男", "女", "男", "女", "女"),
  math = c(4, 3, 2, 4, 3, 4, 5, 4, 5),
  reading = c(1, 5, 2, 4, 5, 4, 1, 5, 4) )

d

#学生（name）と数学（math）のデータを取得せよ。

d |> select(name,math)

#性別（gender）以外のデータを取得せよ。

d |> select(-gender)

#3~6番目のレコードを取得せよ

d |> slice(3:6)

#名前のアルファベット順になるようにレコードをソートせよ。

d |> arrange(name)

#数学の点数を高い方から低い順（降順: descending order）になるようにソートせよ。

d |> arrange(desc(math))

#低い方からはdescはいらない

#数学，国語の点数を高い方から低い順（降順: descending order）になるようにソートせよ。なお，数学の順位を最優先とする。

d |> arrange(desc(math),desc(reading))

#名前（name）と国語（reading）の列のみを抽出せよ。

d |> select(name,reading)

#数学（math）の平均値を計算せよ。

d |> summarize(mean(math))

#先生（teacher）ごとに数学（math）の平均値を計算せよ。

d |> group_by(teacher) |> summarise(math_mean = mean(math))

#女子の数学（math）の点数を取得せよ。

d |> filter(gender == "女") |> select(name,math)

#南高校の男子の国語（reading）の点数を取得せよ。

d |> filter(gender == "男") |> select(reading)

#学生数が3名以上の先生（teacher）のデータを取得せよ。

d |> group_by(teacher) |> filter(n() >=3) |> ungroup()

#数学（math）と国語（reading）の合計点（total）を作成せよ。

d <- d |> mutate(total = math + reading)

#数学（math）を100点満点に換算（新カラム名：math100）せよ。

d <- d |> mutate(math100 = math / 5 * 100)
