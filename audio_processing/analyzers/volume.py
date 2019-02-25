# volume analyzers
# This is the model of volume to use Fast Fourier Transformation to analysis note energy with note number

import models.notes

volume_based_rating_factor = 0.5

def calculate_volume_score(note):

    ref_note_freq = [2.2, 3.3, 1.0]
    scores = 0
    for i in ref_note_freq:
        scores += (note.frequency[i] - ref_note_freq[i]) * volume_based_rating_factor

    return scores

