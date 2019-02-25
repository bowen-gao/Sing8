#!/usr/bin/env python3

import sys, os
from os.path import abspath
from os.path import dirname

# 获取当前工作路径
workDir = os.getcwd()
print('启动目录为: ', workDir)
os.chdir(abspath(dirname(__file__)))
print('修改当前工作目录为: ', os.getcwd())

import app

sys.path.insert(0, abspath(dirname(__file__)))


application = app.configured_app()

if not application.debug:
    import logging
    stream_handler = logging.StreamHandler()
    stream_handler.setLevel(logging.INFO)
    application.logger.addHandler(stream_handler)