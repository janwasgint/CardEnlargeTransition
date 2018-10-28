# CardEnlargingTransition

Present a ViewController originating from a card (UIView).

## Usage
To present a ViewController originating from a card, the presenting ViewController has to inherit from `CardAnimationViewController`. Then in `prepare(for segue: ...)` call

```
cardEnlargeTransition(cardView: cardView, toVC: segue.destination)
```

That's it!

## Demo
![](https://github.com/janwasgint/CardEnlargeTransition/blob/master/demo.gif)

## License

Free to use, also commercially. Happy about credits. Please leave a star and tell me if you could use my Framework.

