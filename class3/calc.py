import pandas as pd
import matplotlib.pyplot as plt
import io
import re
import matplotlib.font_manager as fm

def plot_single_run_hash_performance(data_file_path="data.txt"):
    try:
        plt.rcParams['font.sans-serif'] = ['Hiragino Sans', 'Arial']
    except:
        print("warn ")
        pass
    
    try:
        with open(data_file_path, 'r', encoding='utf-8') as f:
            data = f.read()
    except FileNotFoundError:
        print(f"エラー: ファイル '{data_file_path}' が見つかりません。")
        return
    
    # ターゲットとなるヘッダー行を見つける
    HEADER = "ALPHA,NUM_INSERTED,AVG_SEARCH_TIME_SEC"
    start_index = data.find(HEADER)
    
    if start_index == -1:
        print(f"エラー: ヘッダー '{HEADER}' が見つかりません。")
        return
    
    data_section = data[start_index:].strip()
    
    lines = data_section.split('\n')
    table_lines = [lines[0]] 

    for line in lines[1:]:
        stripped_line = line.strip()
        if not stripped_line or stripped_line.startswith('---'):
            break
        
        if re.match(r'^\d\.\d,', stripped_line):
             table_lines.append(stripped_line)

    table_string = '\n'.join(table_lines)

    if len(table_lines) <= 1:
        print("エラー: 抽出されたデータテーブルにデータ行がありません。")
        return
        
    try:
        # StringIOを使って文字列からPandas DataFrameとして読み込む
        df = pd.read_csv(io.StringIO(table_string))
    except pd.errors.EmptyDataError:
        print("エラー: 抽出されたデータテーブルが空です。")
        return
    

    df['AVG_SEARCH_TIME_SEC'] = pd.to_numeric(df['AVG_SEARCH_TIME_SEC'])
    plt.figure(figsize=(10, 6))
    plt.plot(df['ALPHA'], df['AVG_SEARCH_TIME_SEC'], 'o-', 
         markersize=4, linewidth=1, color='black')
    
    plt.title('二重ハッシュ法における占有率($\\alpha$)と平均探索時間')
    plt.xlabel('占有率 $\\alpha$')
    plt.ylabel('1回の探索あたりの平均時間 [sec]')
    
    # y軸の値を科学表記法で表示
    plt.ticklabel_format(axis='y', style='sci', scilimits=(0,0))
    
    plt.grid(True, linestyle='--', alpha=0.6)

    file_name = "hash_performance.png"
    plt.savefig(file_name)
    print(f"\n--- グラフを {file_name} に保存しました ---")
    
    plt.show()

# 関数を実行
if __name__ == '__main__':
    plot_single_run_hash_performance()