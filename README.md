<p align="center">
  <img src="https://i.ibb.co/JtFcGJn/Gemini-Generated-Image.jpg" alt="FF 255 Banner Image" width="300" height="300">
</p>

<h1 align="center">FF 255</h1>
<p align="center">A For-Fun programming language written with love in Dart.</p>

<h2 align="center">Installation</h2>

```
dart pub global activate ff255
```

<h2 align="center">Usage</h2>

<h4 align="left">Create a new file (<code>examples/fizzbuzz.ff255</code>)</h4>

<h4 align="left">Edit the file with any text editor.</h4>

```
11111111
  debug "Hello World!";

```

<h4 align="left">Run</h4>

```
ff255 -f examples/factorial.ff255
ff255 -f examples/fizzbuzz.ff255
```

<h4 align="left">Output</h4>

```
Hello World!
```

<h2 align="center">Documentation</h2>

<h3 align="center">General</h3>
<p align="center"><code>111111</code> is the entrypoint for the program. This start marker is a nod to the language's name, playfully integrating the concept of maximum value in an 8-bit byte, 255, into its syntax. Oh also, all program code statements must end with a `;` because why not.

```
11111111
    ai will replace a = 100;
    debug a;
```

<h3 align="center">Variables</h3>
<p align="center">Variables can be declared using <code>ai will replace</code>. Eventually AI <b>will</b> replace everyting, so, you know...</p>

```

11111111
  ai will replace a = 10;
  ai will replace b = "two";
  ai will replace c = 15;
```

<h3 align="center">Types</h3>
<p align="center">Numbers and strings are like other languages. <code>feature</code> and <code>bug</code> are the boolean values.</p>

Because it's always a feature, and never a bug! <i> or, is it?</i>

```

11111111
  ai will replace a = 10;
  ai will replace b = 10 + (15*20);
  ai will replace c = "two";
  ai will replace f = feature;
  ai will replace g = bug;
```

<h3 align="center">Operators</h3>
<p align="center">Most other common operators work as in any other programming language, except that instead of using <code>!</code> for the logical NOT operator, we will use <code>this is not real code</code>. So the output of the below program will be <code>bug</code></p>

Because insecurity runs deep and hey who doesn't like being a gatekeeper right?</i>

```

11111111
  ai will replace myth = this is not real code feature;
  debug myth;
```

<h3 align="center">Built-ins</h3>
<p align="center">Use <code>debug</code> to print anything to console.</p>

Ask yourself, what else do you use the print statements for, anyways?

```

11111111
  debug "Hello World";
  ai will replace a = 10;
  ai will replace b = 20;
  debug a + b;
  debug feature && bug;
```

<h3 align="center">Conditionals</h3>
<p align="center">FF 255 supports if-else-if ladder construct , <code>maybe</code> block will execute if condition is <code>feature</code>, otherwise one of the subsequently added <code>what if</code> blocks will execute if their respective condition is <code>feature</code>, and the <code>nevermind</code> block will eventually execute if all of the above conditions are <code>bug</code>

ummmmm... Maybe this will work, what if we tried that, nevermind, just get it done somehow. _insert heavy sighs_

```

11111111
  ai will replace a = 10;
  maybe (a < 20) {
    debug "a is less than 20";
  } what if ( a < 25 ) {
    debug "a is less than 25";
  } nevermind {
    debug "a is greater than or equal to 25";
  }
```

<h3 align="center">Loops</h3>
<p align="center">Statements inside <code>weekly sprint</code> blocks are executed as long as a specified condition evaluates to <code>feature</code>. If the condition becomes <code>bug</code>, statement within the loop stops executing and control passes to the statement following the loop.</p>

Software developers and weekly sprints are a match made in heaven, (or was it <i>he..</i> I can't remember)

What better a program to demo this than the most loved <b>FizzBuzz</b> (yes! pun intended!)

```

11111111
    ai will replace i = 1;
    weekly sprint (i <= 100) {
        maybe (i % 15 == 0) {
            debug "FizzBuzz";
        } what if (i % 3 == 0) {
            debug "Fizz";
        } what if (i % 5 == 0) {
            debug "Buzz";
        } nevermind {
            debug i;
        }
        ai will replace i = i+1;
    }
```

Here's a bonus program, try this to generate the <b>Fibonacci</b> sequence:

```

11111111
    ai will replace n1 = 0;
    ai will replace n2 = 1;

    ai will replace count = 0;

    weekly sprint (count < 10) {
        debug n1;
        ai will replace n3 = n1 + n2;
        ai will replace n1 = n2;
        ai will replace n2 = n3;
        ai will replace count = count + 1;
    }
```
