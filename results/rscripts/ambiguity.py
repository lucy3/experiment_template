"""
wordnet package had JavaVM error
and I'm probably not going to mess with
.dylib files again after what happened
to my computer last time...
"""
from nltk.corpus import wordnet as wn

def main(): 
    words = ["saxophone", "mayonnaise", "milkshake", "pornography", "microphone", 
    "rhinoceros", "undergraduate", "hamburger", "memorandum", "emergency room", "United Nations", 
    "veterinarian", "advertisement", "chimpanzee", "quadrangle", "chemotherapy", "cockroach", 
    "gasoline", "dormitory", "limousine", "quadriceps", "carbohydrates", "telephone", 
    "kilogram", "television", "bicycle", "fraternity", "identification", "Labrador", "United Kingdom",
    "refrigerator", "Coca-Cola", "air conditioning", "referee", "photograph", "United States", 
    "hippopotamus", "laboratory", "examination", "mathematics", "sax", "mayo", "shake", 
    "porn", "mic", "rhino", "undergrad", "burger", "memo", "ER", "U.N.", "vet", "ad", 
    "chimp", "quad", "chemo", "roach", "gas", "dorm", "limo", "quads", "carbs", 
    "phone", "kilo", "TV", "bike", "frat", "ID", "Lab", "U.K.", "fridge", "Coke", 
    "A/C", "ref", "photo", "U.S.", "hippo", "lab", "exam", "math"]
    ambiguity = []
    for word in words:
        ambiguity.append(len(wn.synsets(word)))
    print ambiguity

if __name__ == '__main__':
    main()
