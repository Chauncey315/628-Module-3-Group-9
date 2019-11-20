#!/bin/bash

# This is to clean data(csv) about business, review, tips, user
# by Chauncey in Group 9 for Wisc Stat628 module3

# clean business.csv
python clean_asianrestaurant_business.py 
echo "Finished on business.csv"
# clean review.csv
python clean_asianrestaurant_review.py
echo "Finished on review.csv"
# clean tips.csv
python clean_asianrestaurant_tips.py
echo "Finished on tips.csv"
# clean user.csv
python clean_asianrestaurant_user.py 
echo "Finished on user.csv"