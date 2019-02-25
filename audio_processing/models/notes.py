import time

from . import ModelMixin
from . import db
from analyzers.rhythm import calculate_rhythm_score
from analyzers.volume import calculate_volume_score
from analyzers.pitch import calculate_pitch_score


class Note(db.Model, ModelMixin):
    __tablename__ = 'notes'
    id = db.Column(db.Integer, primary_key=True)
    task = db.Column(db.Text())
    created_time = db.Column(db.Integer, default=0)
    updated_time = db.Column(db.Integer)


    def __init__(self, form):
        print('chest init', form)
        self.id = 1
        self.note_number = 1
        self.score = 0
        self.frequency = [1.2, 3.3, 1.8]
        self.time = 2.2

    @classmethod
    def get_rhythme_scores(cls, id):
        note = cls.query.get(id)
        scores = calculate_rhythm_score(note)
        return scores

    @classmethod
    def get_volume_scores(cls, id):
        note = cls.query.get(id)
        scores = calculate_volume_score(note)
        return scores

    @classmethod
    def get_pitch_scores(cls, id):
        note = cls.query.get(id)
        scores = calculate_pitch_score(note)
        return scores

    @classmethod
    def get_all_scores(cls):
        scores = 0
        # for note in notes:
        #     scores += note.score
        return scores

    @classmethod
    def get_result(cls):
        # should get from note
        #id = 1
        #scores = Note.get_all_scores(1)

        result = {
            'song_name': "No More ! - Higher Brother / NIKI",
            'note_number': 11230,
            'song_len': '02:53',
            'pitch_factor': 0.2,
            'rhythm_factor': 0.5,
            'volume_factor': 0.3,
            'pitch_score': '76.3612 / 100',
            'rhythm_score': '61.2723 / 100',
            'volume_score': '81.8966 / 100',
            'final_score': '78.1135'
        }

        return result



