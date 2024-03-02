# vivado合成コマンド
## 実行方法
```bash
./synth.sh <top_module> [<module1> <module2> ...]
```
## 処理の流れ
1. コマンドライン引数からmoduleファイルを取得
2. 以下のsynth.tclを作成
```tcl:synth.tcl
read_verilog <top_module> [<module1> <module2> ...]
synth_design -top <top_module> -part xc7a100tcsg324-3
report_utilization               -file report_utilization.txt
report_utilization -hierarchical -file report_utilization-hierarchical.txt
report_timing_summary -file report_timing.txt -report_unconstrained
```
3. 以下のコマンドを実行
```bash
vivado -mode batch -nolog -nojournal -source <2で生成したtcl>;
```
4. 2で生成したtclを削除
