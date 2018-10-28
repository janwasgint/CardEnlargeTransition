# CardEnlargingTransition

Present a ViewController originating from a card (UIView)/

## Demo
![](https://github.com/janwasgint/CardEnlargingTransition/blob/master/demo.gif)

## Usage
To present a ViewController originating from a card, the presenting ViewController has to inherit from `CardAnimationViewController`. Then in `prepare(for segue: ...)` call

```
cardEnlargeTransition(cardView: cardView, toVC: segue.destination)
```

That's it!


## License

Free to use, also commercially. Happy about credits. Please leave a star and tell me if you could use my Framework.

