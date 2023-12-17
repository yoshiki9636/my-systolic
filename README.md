# my_systolic

My Systolic array with My RISC-V RV32I CPU ( from anotehr repository )
16bit Integer SYstolic array for matrix multiplier
(Currently Japanese document only)

　シストリックアレイ( Systolic array )とは、行列乗算を効率的に行うための演算器アレイです。乗算加算器を縦横に並べてデータを順番に食わせることによって乗算に必要な乗算加算の組み合わせをすべて計算してくれます。例えばGoogle TPUなどはディープラーニング推論向けにシストリックアレイを搭載しております。今回はAMD製Arty A7での動作を目標に、16bit整数シストリックアレイの模型を実験できるようにverilogコードを作成しました。模型なのでまだまだ制約はありますが、手元のArty A7 T35で6x6のシストリックアレイの動作を確認できております。ただし、演算器はverilogで書いてあるため、ほかのFPGAへもポーティングは可能と考えられます。
　本レポジトリのコードは単体ではなく、[my-riscv-rv32i](https://github.com/yoshiki9636/my-riscv-rv32i)のCPUと接続して動作するように簡易的なDMA　IOバスでのI/Fを付けております。実験の際は、my-riscv-rv32iも併せての使用となります。以下の使用手順も併用を前提としております。

# 仕様
・16bitシストリックアレイ演算器　コードジェネレータによりアレイ部分の大きさは可変（8x8の64演算器まで生成実験しましたがタイミングがだんだん厳しくなります）
・16bit x 16bit ⇒ 32bitでの内部加算をして、総和結果を16bitに絞って出力。この際オーバーフロー／アンダーブローは飽和処理をする。
・飽和フラッグを各乗算に対して１ビットずつ別途出力
・16bit read/write I/Oバス I/F
・Arty A7 35Tで、75MHzで動作実績
# 制約
・Gather/Scatter機能は無し。部分行列を自力で読み出し、自分で並べ替える必要あり

# 使用方法
## RTLシミュレーション（デフォルト 2x2を使用する場合）
・本レポジトリおよび、[my-riscv-rv32i](https://github.com/yoshiki9636/my-riscv-rv32i)をクローンしてください。
・./fsimディレクトリを作成し、以下のファイルをコピーしてください。
 ・rtls
  my-systolic/systolic/*.v
  my-systolic/fpga/fpga_all_top.v
  my-systolic/sim/fullsimtop.v
  my-riscv-rv32i/cpu/*.v
  my-riscv-rv32i/io/*.v
  my-riscv-rv32i/mon/*.v
  my-riscv-rv32i/sim/pll_sim.v
・fpga_all_top.vを開いて、defineをTANG_PRIMERに変更
・my-systolic/asmに入り、以下を実行
  $ ./riscv-asm1.pl systolic_test4.asm > ../fsim/test.txt
・my-systolic/fsimに入り、以下を実行
  $ python3 ../tools/matrix_file_gen.py 64 2 a2.csv b2.csv c2.txt
  $ ../tools/split.pl c2.txt
これで実行に必要なファイルはfsimにそろいました。各自のRTLシミュレータでシミュレーション実行してください。筆者はintelの無償提供版のModelsimを使用しています。

## 合成(Arty A7)
・上記fsim/ディレクトリ内のうち、fullsimtop.vおよびpll_sim.vを除くファイルを使用します。
・fsim/uart_if.vの周波数オプションを75MHzにします。
・vivadoを立ち上げ、上記使用ファイルおよび、タイミングとしてsyn/riscv_io_pins.xdcを指定します。
・合成前にPLLを75MHzでインスタンスします。
・あとは合成⇒インプリメント⇒ビットストリーム作成⇒ビットストリームアップロードで完了します。

## 実機動作
・シミュレーションで使用したtest.txtおよびc2.txtが、実行コードおよびデータパターンファイルとなります。なければ上記に従って作成してください。
・teratarmを立ち上げ、シリアル端末を立ち上げます。設定は、端末⇒改行コード　受信：AUTO、シリアルポート　9600bps,8bit,none,1bit,noneとします。
・qを打つと、エコーバックのqが返ってきます。モニターの詳しい使い方は、[my-riscv-rv32i/README-md](https://github.com/yoshiki9636/my-riscv-rv32i)を参考にしてください。
・i00000000と打ちます
・ファイル⇒ファイル転送で、上記test.txtを指定します
・qを打ちます
・w00000000と打ちます
・ファイル⇒ファイル転送で、上記c2.txtを指定します
・qを打ちます
・g00000000と打つと、テストプログラムが実行されます。Lチカが開始されたら、テストはパスとなります。白くLEDが点灯したままであると、failしております。
　上記テストプログラムは、以下のことをしています。
 　・行列Aの1列目データをIO DMA書き込みします
 　・行列Aの2列目データをIO DMA書き込みします
 　・行列Bの1列目データをIO DMA書き込みします
 　・行列Bの2列目データをIO DMA書き込みします
  ・シストリックアレイをスタートさせます
  ・ここまでを３回繰り返します（２回以上動作することを確認するため）
  ・結果行列のパート1をIO DMA読み出しします
  ・結果行列のパート2をIO DMA読み出しします
  ・結果行列のパート3をIO DMA読み出しします
  ・結果行列のパート4をIO DMA読み出しします
  ・読み出した結果とあらかじめ設定していた結果を比較して、全部一致したら、Lチカに飛ぶ

## NxN拡張版作成方法
　・tools/gettop.pl n > file　でsystolic4.v相当のファイルを作成します。
 ・tools/getiobuf.pl n > file でiobuf.v相当のファイルを作成します。


@auther		Yoshiki Kurokawa <yoshiki.k963@gmail.com>  
@copylight	2023 Yoshiki Kurokawa  
@license	https://opensource.org/licenses/MIT     MIT license  

@version	0.0 Not Opened  
