import pandas as pd
import matplotlib.pyplot as plt
import io
import re
import matplotlib.font_manager as fm

def plot_single_run_hash_performance(data_file_path="data.txt"):
    try:
        plt.rcParams['font.family'] = 'Hiragino Sans' 
        plt.rcParams['font.sans-serif'] = ['Hiragino Sans', 'Arial']
    except:
        print("warn: ")
        pass
    
    # ----------------------------------------------------
    # 2. データ読み込みと最初のブロックの抽出
    # ----------------------------------------------------
    try:
        with open(data_file_path, 'r', encoding='utf-8') as f:
            data = f.read()
    except FileNotFoundError:
        print(f"エラー: ファイル '{data_file_path}' が見つかりません。")
        return

    # 最初の計測結果ブロック（"ALPHA,NUM_INSERTED,AVG_SEARCH_TIME_SEC"）を抽出
    blocks = re.split(r'--- 読み込み完了 ---', data)[1:]
    
    if not blocks:
        print("エラー: データの形式が正しくありません。計測結果が見つかりません。")
        return

    # 最初の計測結果ブロックのみを使用
    first_block = blocks[0]
    
    start_index = first_block.find("ALPHA,NUM_INSERTED,AVG_SEARCH_TIME_SEC")
    end_index = first_block.find("--- 処理終了 ---")
    
    if start_index == -1:
        print("エラー: ヘッダー 'ALPHA,NUM_INSERTED,AVG_SEARCH_TIME_SEC' が見つかりません。")
        return

    # データテーブル部分を抽出
    table_string = first_block[start_index:end_index].strip()
    
    # ----------------------------------------------------
    # 3. DataFrameへの変換
    # ----------------------------------------------------
    try:
        # StringIOを使って文字列からPandas DataFrameとして読み込む
        df = pd.read_csv(io.StringIO(table_string))
    except pd.errors.EmptyDataError:
        print("エラー: 抽出されたデータテーブルが空です。")
        return

    # ----------------------------------------------------
    # 4. プロット
    # ----------------------------------------------------
    plt.figure(figsize=(10, 6))
    plt.plot(df['ALPHA'], df['AVG_SEARCH_TIME_SEC'], 
             marker='o', linestyle='-', color='b')
    
    plt.title('二重ハッシュ法における占有率($\\alpha$)と平均探索時間')
    plt.xlabel('占有率 $\\alpha$')
    plt.ylabel('1回の探索あたりの平均時間 [sec]')
    
    # y軸の値を科学表記法で表示
    plt.ticklabel_format(axis='y', style='sci', scilimits=(0,0))
    
    plt.grid(True, linestyle='--', alpha=0.6)
    
    # ★画像の保存と表示
    file_name = "hash_performance.png"
    plt.savefig(file_name)
    print(f"\n--- グラフを {file_name} に保存しました ---")
    
    plt.show()

# 関数を実行
if __name__ == '__main__':
    plot_single_run_hash_performance()