
import logging; logging.basicConfig(level=logging.INFO)

import asyncio, os, json, time
from datetime import datetime

from aiohttp import web

'''
def index(request):
    return web.Response(body=b'<h1>Instance</h1>')

@asyncio.coroutine
def init(loop):
    app = web.Application(loop=loop)
    app.router.add_route('GET','/',index)
    srv = yield from loop.create_server(app.make_handler(), '127.0.0.1', 9000)
    logging.info('server started at http://127.0.0.1:9000...')
    return srv
'''

import orm
from models import User, Blog, Comment

@asyncio.coroutine
def init(loop):
    yield from orm.create_pool(loop=loop, user='root', password='Love9999', db='awesome')

    u = User(name='Test', email= 'test@localhost.com', passwd='111111', image='http://mt-avatar.qiniudn.com/2016/01/20/1291cf8b273ff1f2c1200531a5a6921f.png')

    yield from u.save()

#for x in test():
#    pass


loop = asyncio.get_event_loop()
loop.run_until_complete(init(loop))
loop.run_forever()
