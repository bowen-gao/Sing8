from flask import Flask
app = Flask(__name__)

from models import db
from models.todo import Todo
from models.user import User
from models.notes import Note


@app.route('/')
def hello_world():
    return 'Hello World!'


@app.route('/get_scores')
def scores():
    # initialize a note
    # file ="/usr/yht/music/NoMore.mp3"
    # # or get from API / database online
    # file = "database//:"
    # nt = Note(file)
    # Note.get_rhythme_scores()
    # Note.get_pitch_scores()
    # Note.get_volume_scores()

    data = Note.get_result()
    import json
    return json.dumps(data, sort_keys=True, indent=4)


def processing(file):
    pass

if __name__ == '__main__':

    config = dict(
        debug=True,
        host='0.0.0.0',
        port=8888,
    )
    app.run(**config)