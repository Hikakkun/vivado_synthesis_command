#!/bin/bash

main() {


    # 引数の数が少なくとも1つ以上あることを確認
    if [ "$#" -lt 1 ]; then
        echo "Usage: $0 <top_module> [<module1> <module2> ...]"
        exit 1
    fi

    # 1番目の引数を単一の変数に格納
    top_module=$1

    # 2番目以降の引数が存在する場合、それらを配列に格納
    if [ "$#" -gt 1 ]; then
        modules=("${@:2}")
    else
        modules=()  # 引数が1つしかない場合、空の配列として初期化
    fi

    # top_moduleの表示
    echo "Top Module: $top_module"

    # modulesが空でない場合、その内容を表示
    if [ ${#modules[@]} -gt 0 ]; then
        echo "Modules:"
        for module in "${modules[@]}"; do
            echo "  $module"
        done
    fi

    top_module_name="${top_module%.*}"
    echo $top_module
    echo $top_module_name
# スクリプトの内容
    script_content=$(cat <<EOF
read_verilog $top_module ${modules[@]}
synth_design -top $top_module_name -part xc7a100tcsg324-3
report_utilization               -file report_utilization.txt
report_utilization -hierarchical -file report_utilization-hierarchical.txt
report_timing_summary -file report_timing.txt -report_unconstrained
EOF
)

    current_directory=$(pwd)
    tcl_path="${current_directory}/synth.tcl"
    echo "tcl file generate path:${tcl_path}"
    # ファイルにスクリプトを書き込む
    echo "$script_content" > $tcl_path
    echo "--------------------------------------"
    echo "$script_content"
    echo "--------------------------------------"

    return_value=0
    echo "exec 'vivado -mode batch -nolog -nojournal -source ${tcl_path}'"
    if ! vivado -mode batch -nolog -nojournal -source ${tcl_path}; then
        echo "Please download vivado and pass the pass"
        return_value=1
    fi
    
    echo "remove ${tcl_path}"
    rm ${tcl_path}
    return $return_value
}

# main関数呼び出し
main "$@"