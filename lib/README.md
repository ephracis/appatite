# Libraries

In this folder we put all code that is not domain specific.

To determine if a class is domain specific, ask the question:

> Can I use this code in another Rails app providing a social network for turtles?

If the answer is *no*, then the code should go into `app/`, if the answer is
*yes* then the code should be here in `lib/`.

The following is a short summery of the various libraries in this folder.

## Backends
Code for communicating with service backends such as Gitlab and Github, allowing
us to retrieve and push data from/to the backend.