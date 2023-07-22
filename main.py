#!/usr/bin/env python3

import spacy
import ru_core_news_lg

nlp = ru_core_news_lg.load()

text = input()
text = nlp(text)
for word in text:
    print(word.lemma_, end=' ')
print()
