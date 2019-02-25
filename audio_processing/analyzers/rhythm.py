
import models.notes

rhythm_based_rating_factor = 0.3

def calculate_rhythm_score(note):
    ref_time = 2.34
    scores = (note.time - ref_time) * rhythm_based_rating_factor

    return scores