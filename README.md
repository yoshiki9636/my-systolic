# my_systolic

My Systolic array with My RISC-V RV32I CPU ( from anotehr repository )
16bit Integer SYstolic array for matrix multiplier
(Japanese Follows English)

### English

　Systolic arrays are arrays of arithmetic units used to efficiently perform matrix multiplication. By arranging multiply-adders vertically and horizontally and feeding them data in sequence, it calculates all the necessary multiply-add combinations for multiplication. Google TPU, for example, has a systolic array for deep learning inference. We have created verilog code to experiment with a model of a 16-bit integer systolic array, with the goal of running on AMD's Arty A7. Although there are still some limitations since it is a model, we have confirmed the operation of a 6x6 systolic array on an Arty A7 T35 at hand. However, since the arithmetic unit is written in verilog, porting to other FPGAs is also possible.
　The code in this repository is not stand-alone, but has an I/F with a simple DMA IO bus to connect and operate with the CPU of [my-riscv-rv32i](https://github.com/yoshiki9636/my-riscv-rv32i). In the experiment, my-riscv-rv32i will also be used together. The following usage procedure is also based on the assumption that the two devices will be used together.

# Specifications
16-bit systolic array operator The size of the array portion can be varied by the code generator (we have experimented with generating up to 64 8x8 operators, but the timing is getting tougher and tougher).

16bit x 16bit ⇒ Internal addition at 32bit is performed and the summed result is reduced to 16bit for output. In this case, overflow/underblow is saturated.

Output saturation flags separately, one bit for each multiplication

16bit read/write I/O bus I/F

Arty A7 35T, operating at 75MHz

# Constraints
No Gather/Scatter function. Need to read out the submatrix by yourself and rearrange it by yourself.

# Usage
## RTL simulation (using default 2x2)
Clone this repository and [my-riscv-rv32i](https://github.com/yoshiki9636/my-riscv-rv32i).

. Create the /fsim directory and copy the following files
 ... rtls
 
  my-systolic/systolic/*.v
  
  my-systolic/fpga/fpga_all_top.v
  
  my-systolic/sim/fullsimtop.v
  
  my-riscv-rv32i/cpu/*.v
  
  my-riscv-rv32i/io/*.v
  
  my-riscv-rv32i/mon/*.v
  
  my-riscv-rv32i/sim/pll_sim.v

Open fpga_all_top.v and change define to TANG_PRIMER

Enter my-systolic/asm and execute the following
  $ ./riscv-asm1.pl systolic_test4.asm > ../fsim/test.txt

Enter my-systolic/fsim and execute the following
  $ python3 ../tools/matrix_file_gen.py 64 2 a2.csv b2.csv c2.txt
  $ ../tools/split.pl c2.txt

Now you have all the files you need to run the simulation in fsim. Please run the simulation on your RTL simulator. The author uses Modelsim, a free version provided by intel.

## Synthesis (Arty A7)
Use the files in the above fsim/ directory except fulsimtop.v and pll_sim.v.

∙ Set the frequency option in fsim/uart_if.v to 75 MHz.

Launch vivado and specify the above file and syn/riscv_io_pins.xdc as timing.

Instance the PLL at 75MHz before synthesis.

The rest is done by Composite => Implement => Create Bitstream => Upload Bitstream.

## Actual operation
The test.txt and c2.txt files used in the simulation will be the executable code and data pattern files. If not, please create them according to the above.

Start up "teratarm" and start up the serial terminal. Set terminal => Newline code Receive: AUTO, Serial port: 9600bps, 8bit, none, 1bit, none.

. When you hit q, an echo-back q will be returned. Please refer to [my-riscv-rv32i/README-md](https://github.com/yoshiki9636/my-riscv-rv32i) for detailed usage of the monitor.

Type i00000000.

In File⇒File Transfer, specify the above test.txt file.

I'll type q.

I'll type w00000000.

In File⇒File Transfer, specify the above c2.txt file.

I'll type q.

If you type g00000000, the test program will run. if L-tika starts, the test has passed. If the white LED remains lit, the test has failed.

 The above test program does the following
 
  Writes the first row data of matrix A to IO DMA

  Writes the second row data of matrix A to IO DMA

  Writes IO DMA to the first row data of matrix B

  Writes the second row data of matrix B to IO DMA
  
  We will start a systolic array.
  
  Repeat three times (to make sure it works at least twice)
  
  IO DMA reads part 1 of the result matrix
  
  IO DMA reads part 2 of the result matrix
  
  IO DMA reads part 3 of the result matrix
  
  IO DMA reads part 4 of the result matrix
  
  Compare the readout results with the predefined results, and if they all match, jump to L-Thica.

## How to create NxN extended version
　Create a file equivalent to systolic4.v with tools/gettop.pl n > file.

 Create a file equivalent to iobuf.v with tools/getiobuf.pl n > file.


### Japanese

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


---------
@auther		Yoshiki Kurokawa <yoshiki.k963@gmail.com>  
@copylight	2023 Yoshiki Kurokawa  
@license	https://opensource.org/licenses/MIT     MIT license  

@version	0.0 Not Opened  
