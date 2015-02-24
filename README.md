# Quiz Nerd #

### About the Application ####

This is an application that provides functionality in support of education. It provides 3 major capabilities:
  * Quizzes: you can create quizzes and take quizzes. You can take your own quizzes or any quiz that has been made public by the author.
  * Flash Cards: you can create flash card decks and "play" the flash cards. You can self-report on which ones you answered correctly and which ones you missed, and the application provides you with the option to use that data to customize your next study session with that deck.
  * Cheatsheets: these are notes, long or short, that you can tag with keywords to help you find them later on. The search capability allows you to search via tag name or words in the title or content of the cheatsheet.

It is deployed on Heroku at http://quiznerd.herokuapp.com if you want to see it in action. (Keep in mind that if the app hasn't been used recently, it will take some time for Heroku to spin it up for you.)

It uses:

* Ruby version: 2.1.1
* Rails version: 4.1.1
* Rspec 
* Capybara
* FactoryGirl
* Twitter Bootstrap
* Simple Form
* Devise
* jQuery
* Postgres 
* Postgres full text search

### Why? ###

After a career spent mostly in the world of Java, I decided to learn Ruby and Rails. I needed this functionality and didn't like the apps that were "free" out there. I also needed a project to work on, because that's the best way to learn.

### Notes on the Code ###

This project is for learning, so sometimes I implemented things that were not needed, or  implemented two similar things in a different way, just to broaden my experience. For instance, I cached much of what appears on the dashboard - not technically necessary at this point, since I'm the only user! 

I developed the "Merge Quizzes" functionality, which allows you to merge two existing quizzes into one, even though I didn't have a strong need for it. Why do it, then? I was looking for a use case that was not a straight-forward CRUD operation so that I could explore how to do it in a RESTful manner. I was also looking for something that was an enhancement to existing models, so I could prove to myself that you can indeed add functionality while still respecting the Open-Closed Principle (OCP). "Merge Quizzes" was implemented without opening up the Quiz model or the QuizzesController. Yay!

One example of "I probably wouldn't do this in a production app" was using accepts_nested_attributes_for :answers" on the Question model. Yes, some people frown on that and would prefer a form object instead, but I wanted see how easy or difficult it was. (It was easy.) 

A note on the models: most of it is hopefully self-explanatory, but naming is hard and I had difficulty in two areas: 

What do I call the "taking" of a quiz. The quiz itself is obviously Quiz, but what about when a user "takes" a quiz? Ugh. Naming is hard. I ended up calling it a QuizEvent. 

Same thing applies to Flash Card Decks. The act of studying or "playing" a set of flash cards is a DeckEvent.

#### Refactoring QuizEvent (Use a Form) ####

After doing the initial development, I looked through the application for ways to improve it. One of the issues I had was that the QuizEvent class, which is the model used by the "User Takes a Quiz" use case, was starting to get large. In any application, the class at the center of the application will tend to grow large and if left unchecked will start to smell like a God class. In my application, the God candidates would be User, Quiz, and QuizEvent. While User and Quiz stayed managably small, QuizEvent needed some work.

In the "user takes a quiz" scenario, the only thing that is persisted is the end result: the quiz that was taken, the user who took it, how many questions, how many correct answers, that sort of thing. The individual questions and user-selected answers are not saved. 

Therefore, much of what was in the QuizEvent model was really handling interactions with the user with data that wasn't being persisted, like serving up the current question, grading the user's answer, and then serving up another question. 

These things could be extracted out into a Form object. The form object is now responsible for handling interactions with the user and the QuizEvent model is only used for the persistent data. 

In addition to that, I also introduced a presenter (decorator) to further extract out display logic, allowing me to significantly clean up the views. I could have used a gem like Draper, but it was simple enough that I decided to just roll my own. (Thanks to Ryan Bates's Railscasts!)

#### Refactoring Quiz (Use a Service Object) ####

Quiz stayed reasonably small, but even so, I noticed that it was handling some things that it shouldn't. It was sometimes called upon to create Categories and Subjects, when clearly those things should not be the responsibility of Quiz. The reason for this transgression is that the "Create Quiz" form (and Edit, too) allows you to select a category from a drop down, OR just type a new one into a text area field and it will be created for you and assigned to that Quiz (just a convenience feature for the user).

Since creating a Quiz now involved collaboration between multiple models, I introduced a service object to handle creating a Quiz, and creating the Category and Subject, too, as needed. 

#### Tags ####

I originally intended only to tag cheatsheets, but as I started implementing it, I thought it would be more interesting to make it a polymorphic many to many relationship. So cheatsheets are taggable, as are Flash Card Decks, and they can each have multpiple tags.

#### Facades ####

In the few cases where I found myself creating multiple instance variables in a controller, I created a facade class instead. This helps me keep in line with Sandi Metz's rules. (Controllers can instantiate only one object. Therefore, views can only know about one instance variable.)

The Dashboard for the home page is the most obvious case for this, but there are a couple of others. Someone asked me why a facade and not a presenter. A presenter typically decorates one object, whereas a facade provides a single access point for multiple objects. Different things.

#### Concers ####

Do you have concerns about concerns? Yeah, me too. But I still moved my Finder functionality for some of the models into a module in the concerns folder. I know, I know, it just moving items out of a junk drawer and into another one. As much as I wanted to make them separate classes, I couldn't easily do it due to the use of Postgres' full text search functionality. 

#### What's Next? ####

There are a few things I am currently looking at. 

* One is to use Redis for something, just cuz.

* The other is to add an api interface to this app and create a different front end using AngularJS, or maybe Ember, neither of which I currently know.

* And finally, I'd like to use ActiveJob for something.








