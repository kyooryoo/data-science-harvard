ls() # a function that lists out the objects in the workspace
ls # show the implementation of the function but not invoke it

help(log) # getting the help document for the function log()
?log # another short cut way to get the help for a function
# check the help for arithmetic operators
help("+")
?"+"

number_1 <- 10 # use lower case char and _ for var name
exp(log(number_1)) # nested two inverse functions

# the log function has the natural number as its default base
log(x=8) # use function arg name explicitly
# the log with specified base
log(x=8, base=2) # use function with an optional arg
log(base=2, x=8) # with explicit arg name their order is not important
args(log) # check the args required for the function log()

# check the currently available datasets
data()
# some other pre-built constant
pi