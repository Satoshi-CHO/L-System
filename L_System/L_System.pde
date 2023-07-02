/* //<>//
  L-Systemの簡易実装
  setup で　初期値、ルール、線の長さ、回転角度などを設定
  
  実行後、
  左クリック：世代を増やす
  右クリック：表示を縮小する
*/

String current; //初期値

ArrayList<String[]> rules = new ArrayList<String[]>();

// 描画関連
int len = 10;              // 線の長さ
float angle = radians(36); // +,-の回転角度

// 初期座標
int initPosX = 250; // 描画の出発x座標
int initPosY = 250; // 描画の出発y座標
float initAngle = radians(0); // 描画出発方向

boolean redraw = true;
int generation;
int small;
void setup() {
  size(500, 500);
  
  // 以下を編集対象とする
  // ルールを追加する場合、この行をコピペして記述（下のペンローズタイルを参考にする）
  rules.add(new String[]{"",""}); 
  current = "";              // 初期値を記述
  angle = radians(30);        // +,-の時の角度
  // 編集対象おわり

  /*
  // ペンローズタイルの設定　開始
  // ルール 例: rules.add(new String[]{"置き換え前の文字","置き換え後の文字(列)"});
  rules.add(new String[]{"M", "OA++PA----NA[-OA----MA]++"});
  rules.add(new String[]{"N", "+OA--PA[---MA--NA]+"});
  rules.add(new String[]{"O", "-MA++NA[+++OA++PA]-"});
  rules.add(new String[]{"P", "--OA++++MA[+PA++++NA]--NA"});
  rules.add(new String[]{"A", ""});

  // 初期値
  current = "[N]++[N]++[N]++[N]++[N]";
  
  // 描画位置の設定
  initPosX = 250; // 描画開始位置X
  initPosY = 250; // 描画開始位置Y
  initAngle = radians(0); // 描画出発方向
  len = 10; // 線の長さ
  angle = radians(36); // +,-の回転角度
  // ペンローズタイルの設定　終了
  */
  /*
  // コッホ曲線の設定　開始
  rules.add(new String[] {"F", "F+F-F-F+F"});
  current = "F";
  initPosX = 0; // 描画開始位置X
  initPosY = 490; // 描画開始位置Y
  initAngle = radians(90); // 描画出発方向
  angle = radians(90);
  // コッホ曲線の設定　終了
  */
  
  generation = 1;
  small = 1;
}

void draw() {
  if (redraw) {
    background(255);
    turtle(current);
    println(current);
    redraw = false;
  }
}

// 文字列を生成する関数
void generate() {
  String next = "";
  for (int i = 0; i < current.length(); i++) {
    boolean flag = false;
    for (String[] rule : rules) {
      if (rule[0].charAt(0) == current.charAt(i)) {
        next += rule[1];
        flag = true;
        break;
      }
    }
    if (!flag) next += current.charAt(i);
  }
  current = next;
}

// マウスの左ボタンで次の世代へ
// マウスの右ボタンで縮小
void mouseClicked() {
  if (mouseButton == LEFT) {
    generate();
    generation++;
    redraw = true;
  } else if (mouseButton == RIGHT) {
    small++;
    redraw = true;
  }
}

void turtle(String str) {
  resetMatrix();
  translate(initPosX, initPosY);
  rotate(initAngle);
  scale(1.0/small);
  for (int i = 0; i < str.length(); i++) {
    // 文字だったら線を描画する
    if('a' <=str.charAt(i) && str.charAt(i) <= 'z' || 'A' <=str.charAt(i) && str.charAt(i) <= 'Z'){  
      line(0, 0, 0, -len);
      translate(0, -len);
    } else if (str.charAt(i)=='+') {
      // +だったら回転(反時計まわり)
      rotate(-angle);
    } else if (str.charAt(i)=='-') {
      // -だったら回転（時計回り）
      rotate(angle);
    } else if (str.charAt(i)=='[') {
      // [ だったら記憶
      push();
    } else if (str.charAt(i)==']') {
      // ] だったら戻す
      pop();
    }
  }
}
