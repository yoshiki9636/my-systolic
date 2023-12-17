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

# 使用方法
 


@auther		Yoshiki Kurokawa <yoshiki.k963@gmail.com>  
@copylight	2023 Yoshiki Kurokawa  
@license	https://opensource.org/licenses/MIT     MIT license  

@version	0.0 Not Opened  
