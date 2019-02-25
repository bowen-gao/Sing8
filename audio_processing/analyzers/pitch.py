# pitch analyzers
# This is the model of pitch to compare the reference sequence with test sequence for each notes


pitch_based_rating_factor = 0.3

def calculate_pitch_score(note):
    ref_note_number = 0
    scores = (note.note_number - ref_note_number) * pitch_based_rating_factor

    return scores
