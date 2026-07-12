# Cars — a measurement instrument for Compy

Four cars drive along four lanes. Three hold a constant
speed; one accelerates. Children time each car with a
physical stopwatch as it crosses milestone lines, plot the
readings on paper coordinate grids, and discover that
steady cars draw straight lines while the accelerating one
draws a curve.

Written for the [Compy](https://github.com/compy-toys/compy/)
project. This is not a game — it is an apparatus. The screen
provides a perfectly reproducible phenomenon; the stopwatch,
pencil, and ruler are the instruments. Every run is
identical, so repeated measurements converge.

Start it from the Compy console:

```
run "cars"
```

## What happens

Press `Space`. A large 3-2-1 countdown fills the screen, a
soft knock marks **Go!**, and the cars start the instant the
word appears — the children's stopwatches and the cars share
one zero. Each time a car crosses a milestone line, a gentle
band of its color glows on the line and fades; that is the
cue to stop the stopwatch. An elapsed-time counter in the
top-right corner runs as a backup for anyone who missed a
reading.

When every car has passed the last line the run ends by
itself: the cars stay where they stopped, the counter
freezes, and a soft chime tells the room the run is over.

## Milestone times

| Car    | Profile        | Line 1 | Line 2 | Line 3 | Line 4 |
|--------|----------------|--------|--------|--------|--------|
| Red    | constant, slow | 4.0 s  | 8.0 s  | 12.0 s | 16.0 s |
| Blue   | constant, med  | 2.5 s  | 5.0 s  | 7.5 s  | 10.0 s |
| Green  | constant, fast | 1.5 s  | 3.0 s  | 4.5 s  | 6.0 s  |
| Yellow | accelerating   | 6.0 s  | 8.5 s  | 10.4 s | 12.0 s |

The yellow car reaches the last line at nearly the same time
as the blue one, but distributes that time very differently —
that difference is the lesson.

## Controls

For the children:

- `Space` — start the run; pause; continue.
- `R` — reset everything to the start. Also `Shift+Esc`.

For the teacher (hidden, for the prediction rounds):

- `M` — toggle milestone line 5, placed 1.25 spacings past
  line 4, for "when will it arrive?" predictions.
- `P`, digits, `Enter` — freeze the run at that many seconds.
  Dashed lines in each car's color mark the frozen positions
  for "where will it be?" predictions. `P` again clears the
  pause point. The pause point re-arms on every start until
  cleared.

Everything else is ignored. There is no score, no losing,
and nothing to break: reset or relaunch always returns to
the same initial state.

## License

MIT — see [LICENSE](LICENSE).
