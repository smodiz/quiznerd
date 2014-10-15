# Quiz Nerd #

This is an application that allows you to create your own quizzes and take quizzes. You can take your own quizzes or any quiz written by another that has been made public by the author.  

It is deployed on Heroku at http://quiznerd.herokuapp.com if you want to see it in action. (Keep in mind that if the app hasn't been used recently, it will take some time for Heroku to spin it up for you.)

It uses:

* Ruby version: 2.1.1
* Rails version: 4.1.1
* Rspec 
* Twitter Bootstrap
* Simple Form
* Devise

This project was developed to practice my Ruby and Rails skills. It is a work in progress. There are a number of enhancements that are on my to do list, including the following:

* Make the Answers section smarter within the Create Quiz workflow. Right now, I show four rows for answers by default. The user can manually remove any rows they don't want to use, but there is currently no way to dynamically add rows to the page. 
* Create interaction between the Question Type field and the Answer rows. For example, if I choose True/False, there should be two rows and they should already be labeled True and False. 
* Filter subjects according to Category. 
* Add support for study aids like flash cards and cheat sheets in addition to just quizzes. 
* and many more

After doing the initial development, I looked through the application for ways to improve it. One of the issues I had was that the QuizEvent class, which is the model used by the "User Takes a Quiz" use case, was starting to get large. In any application, the class at the center of the application will tend to grow large and if left unchecked will start to smell like a God class. 

In this application, the only thing that is persisted during this use case is the end result: the quiz that was taken, the user who took it, how many questions, how many correct answers, that sort of thing. The individual questions and answers given are not saved. 

Therefore, much of what was in the QuizEvent model was really handling interactions with the user with data that wasn't being persisted, like serving up the current question, grading the user's answer, and then serving up another question. 

These things could be extracted out into a Form object. The form object is now responsible for handling interactions with the user and the QuizEvent model is only used for the persistent data. 

In addition to that, I also introduced a presenter (decorator) to further extract out display logic, allowing me to significantly clean up the views. I could have used a gem like Draper, but it was simple enough that I decided to just roll my own. (Thanks to Ryan Bates' Railscasts!)









