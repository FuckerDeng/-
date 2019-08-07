import re
from pathlib import Path
import os


ROOT = Path(__file__).resolve().parent.parent.parent
MAIN = ROOT


# 将 iconfont 的 css 自动转换为 dart 代码
# 此代码文件参考自网络

def translate():
    print('开始生成字体类...')

    code = """
import 'package:flutter/widgets.dart';


// 可以根据自己的项目适当修改读取和写入的文件路径


class IconFont {

  IconFont._();

  static const font_name = 'IconFont';

{icon_codes}

}
""".strip()

    strings = []

    tmp = []
    p = re.compile(r'.icon-(.*?):.*?"\\(.*?)";')

    if os.path.exists(MAIN / 'res/fonts/iconfont.css') ==False:
        print("所要读写的文件不存在："+MAIN / 'res/fonts/iconfont.css')
    content = open(MAIN / 'res/fonts/iconfont.css').read().replace('\n  content', 'content')

    for line in content.splitlines():
        line = line.strip()
        if line:
            res = p.findall(line)
            if res:
                name, value = res[0]
                name = name.replace('-', '_')
                tmp.append((name.lower(), value))

    tmp.sort()
    for name, value in tmp:
        string = f'  static const IconData {name} = const IconData(0x{value}, fontFamily: font_name);'
        strings.append(string)

    strings = '\n'.join(strings)
    code = code.replace('{icon_codes}', strings)

    if os.path.exists(MAIN / 'lib/public') ==False:
        os.makedirs(MAIN / 'lib/public')

    open(MAIN / 'lib/public/IconFont.dart', 'w',encoding="utf-8").write(code)

    print('生成完成！...')
    print("创建目标dar文件："+(str)(MAIN / 'lib/public/IconFont.dart'))


if __name__ == "__main__":
    translate()