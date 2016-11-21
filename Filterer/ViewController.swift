import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    // ui objects
    var filteredImage: UIImage?
    var originalImage: UIImage?
    
    @IBOutlet var OriginalimageView: UIImageView!
    @IBOutlet var FilteredimageView: UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var intensityMenu: UIView!
    @IBOutlet var secondMenuCollection: UICollectionView!
    
    @IBOutlet var bottomMenu: UIView!
    
    @IBOutlet var intensitySlider: UISlider!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var compareButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    
    
    @IBOutlet var overlay: UIView!
    @IBOutlet var red: UIButton!
    @IBOutlet var green: UIButton!
    @IBOutlet var blue: UIButton!
    @IBOutlet var yellow: UIButton!
    @IBOutlet var purple: UIButton!
    
    var original: Bool = true
    var nameOfFilter : String!
    @IBOutlet var intensityLabel: UILabel!
    
    let Filtersamples: [UIImage] = [
        #imageLiteral(resourceName: "yellow"),
        #imageLiteral(resourceName: "grayscale"),
        #imageLiteral(resourceName: "invert"),
        #imageLiteral(resourceName: "sepia"),
        #imageLiteral(resourceName: "brightness"),
        #imageLiteral(resourceName: "red"),
        #imageLiteral(resourceName: "blue"),
        #imageLiteral(resourceName: "green"),
        #imageLiteral(resourceName: "purple")
    ]
    var nameOfTheFilter : String?
    
    @IBOutlet var tapGestureArea: UIView!
    var imageTapGesture: UILongPressGestureRecognizer!
    
    // MARK: First load func
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        intensityMenu.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        intensityMenu.translatesAutoresizingMaskIntoConstraints = false
        
        secondMenuCollection.dataSource = self
        secondMenuCollection.delegate = self

        
        self.originalImage = self.OriginalimageView.image
        
        // Disable Buttons when the app starts
        compareButton.isEnabled = false
        editButton.isEnabled = false
        shareButton.isEnabled = false
        
        // Toggle dislpay
        self.imageTapGesture = UILongPressGestureRecognizer(target:self, action:#selector(ViewController.toggleImage(_:)) )
        self.imageTapGesture.minimumPressDuration = 0.1
        self.imageTapGesture.delegate = self
        self.tapGestureArea.addGestureRecognizer(self.imageTapGesture)
    }
    
    // MARK: Declare Fucn Collection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            nameOfTheFilter = "yellow"
        case 1:
            nameOfTheFilter = "grayscale"
        case 2:
            nameOfTheFilter = "invert"
        case 3:
            nameOfTheFilter = "sepia"
        case 4:
            nameOfTheFilter = "brightness"
        case 5:
            nameOfTheFilter = "red"
        case 6:
            nameOfTheFilter = "blue"
        case 7:
            nameOfTheFilter = "green"
        case 8:
            nameOfTheFilter = "purple"
        default:
            print("Nothing to Do!")
        }
        if nameOfTheFilter != nil {
            click_filterer(filterName: nameOfTheFilter!)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Filtersamples.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionView", for: indexPath) as! CollectionView
        cell.filterImages.image = Filtersamples[indexPath.row]
        
        return cell
    }
    
    // MARK: TouchScreen, called when touch the screen and the image toggle between original and filtered
    func toggleImage(_ gesture: UILongPressGestureRecognizer){
            if(self.filteredImage != nil){
                if (gesture.state == .began){
                    self.ChangeViews(originalImage: !self.original)
                }else if (gesture.state == .ended){
                    self.ChangeViews(originalImage: self.original)
                }
            }
    }
    
    
    // MARK: Share
    @IBAction func onShare(_ sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", FilteredimageView.image!], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            //iOS > 8.0
            if(activityController.responds(to: #selector(getter: UIViewController.popoverPresentationController))) {
                activityController.popoverPresentationController?.sourceView = super.view
            }
        }
    }
    
    // MARK: ToolBar actions
    @IBAction func onNewPhoto(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .actionSheet)
        
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad) {
            
            // iOS > 8
            if(actionSheet.responds(to: #selector(getter: UIViewController.popoverPresentationController))){
                actionSheet.popoverPresentationController?.sourceView = super.view
            }
        }
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: Camera Photo
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .photoLibrary
        
        present(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // scale a new image
            if image.size.height * image.size.width >= 40000 {
                let scaledImage = image.resizeWith(percentage: 0.35)
                OriginalimageView.image = scaledImage
                self.originalImage = scaledImage
            } else {
                OriginalimageView.image = image
                self.originalImage = image
            }
            //OriginalimageView.image = image
            self.OriginalimageView.alpha = 1
            //self.originalImage = image
            
            self.compareButton.isEnabled = false
            self.editButton.isEnabled = false
            self.editButton.isSelected = false
            self.filterButton.isSelected = false
            self.secondaryMenu.removeFromSuperview()
            self.intensityMenu.removeFromSuperview()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(_ sender: UIButton) {
        if (sender.isSelected) {
            hideSecondaryMenu()
            sender.isSelected = false
        } else {
            showSecondaryMenu()
            sender.isSelected = true
        }
    }
    
    // MARK: Edit Menu
    @IBAction func editButton(_ sender: UIButton) {
        if (sender.isSelected) {
            hideIntensityMenu()
            sender.isSelected = false
        } else {
            showIntensityMenu()
            sender.isSelected = true
        }
    }
    
    // MARK: Show Secondary Menu
    func showSecondaryMenu() {
        self.editButton.isSelected = false
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraint(equalToConstant: 61)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.secondaryMenu.alpha = 1
            self.intensityMenu.removeFromSuperview()
        }) 
    }
    
    // MARK: Hide Secondary Menu
    func hideSecondaryMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.secondaryMenu.alpha = 0
            }, completion: { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }) 
    }
    
    // MARK: Intensity Menu
    
    // ShowIntensityProperties
    func showIntensityProperties() {
        self.filterButton.isSelected = false
        view.addSubview(intensityMenu)
        
        let bottomConstraint = intensityMenu.bottomAnchor.constraint(equalTo: bottomMenu.topAnchor)
        let leftConstraint = intensityMenu.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightConstraint = intensityMenu.rightAnchor.constraint(equalTo: view.rightAnchor)
        
        let heightConstraint = intensityMenu.heightAnchor.constraint(equalToConstant: 90)
        
        NSLayoutConstraint.activate([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.intensityMenu.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.intensityMenu.alpha = 1.0
        })
    }
    // Show Intensity Menu
    func showIntensityMenu() {
        if(self.secondaryMenu.alpha>0){
            UIView.animate(withDuration: 0.4, animations: {
                self.secondaryMenu.alpha = 0
            }, completion: { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                    self.showIntensityProperties()
                }
            })
        }else{
            self.showIntensityProperties()
        }
        
    }
    
    // Hide Intensity Menu
    func hideIntensityMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.intensityMenu.alpha = 0
        }, completion: { completed in
            if completed == true {
                self.intensityMenu.removeFromSuperview()
            }
        })
    }
    
    func click_filterer(filterName: String) {
        switch filterName {
        case "yellow":
            let yellowFilter = YellowFilter(intensity: 5)
            yellowFilter.setBaseImage(image: self.originalImage)
            yellowFilter.apply()
            self.filteredImage = yellowFilter.toUIImage()
            self.FilteredimageView.image = self.filteredImage
            self.nameOfFilter = "Yellow"
            self.filter_is_Clicked()
        case "grayscale":
            let grayFilter = GrayScale()
            grayFilter.setBaseImage(image: self.originalImage)
            grayFilter.apply()
            self.filteredImage = grayFilter.toUIImage()
            self.FilteredimageView.image = self.filteredImage
            self.nameOfFilter = "Gray"
            self.filter_is_Clicked()
        case "invert":
            let invert = InvertFilter()
            invert.setBaseImage(image: self.originalImage)
            invert.apply()
            self.filteredImage = invert.toUIImage()
            self.FilteredimageView.image = self.filteredImage
            self.nameOfFilter = "Invert"
            self.filter_is_Clicked()
        case "sepia":
            let sepia = SepiaFilter()
            sepia.setBaseImage(image: self.originalImage)
            sepia.apply()
            self.filteredImage = sepia.toUIImage()
            self.FilteredimageView.image = self.filteredImage
            self.nameOfFilter = "Sepia"
            self.filter_is_Clicked()
        case "brightness":
            let brightness = Brightness(intensity: 2)
            brightness.setBaseImage(image: self.originalImage)
            brightness.apply()
            self.filteredImage = brightness.toUIImage()
            self.FilteredimageView.image = self.filteredImage
            self.nameOfFilter = "Brightness"
            self.filter_is_Clicked()
        case "red":
            let redFilter = RedFilter(intensity: 5)
            redFilter.setBaseImage(image: self.originalImage)
            redFilter.apply()
            self.filteredImage = redFilter.toUIImage()
            self.FilteredimageView.image = self.filteredImage
            self.nameOfFilter = "Red"
            self.filter_is_Clicked()
        case "blue":
            let blueFilter = BlueFilter(intensity: 5)
             blueFilter.setBaseImage(image: self.originalImage)
             blueFilter.apply()
             self.filteredImage = blueFilter.toUIImage()
             self.FilteredimageView.image = self.filteredImage
             self.nameOfFilter = "Blue"
             self.filter_is_Clicked()
        case "green":
            let greenFilter = GreenFilter(intensity: 5)
            greenFilter.setBaseImage(image: self.originalImage)
            greenFilter.apply()
            self.filteredImage = greenFilter.toUIImage()
            self.FilteredimageView.image = self.filteredImage
            self.nameOfFilter = "Green"
            self.filter_is_Clicked()
        case "purple":
            let purpleFilter = PurpleFilter(intensity: 5)
            purpleFilter.setBaseImage(image: self.originalImage)
            purpleFilter.apply()
            self.filteredImage = purpleFilter.toUIImage()
            self.FilteredimageView.image = self.filteredImage
            self.nameOfFilter = "Purple"
            self.filter_is_Clicked()
        default:
            break
        }
    }
    
    // MARK: Filters
    
    
    // MARK: ClickedFilter, called when one of the filters is clicked
    func filter_is_Clicked(){
        compareButton.isEnabled = true
        editButton.isEnabled = true
        shareButton.isEnabled = true
        self.original = false
        self.ChangeViews(originalImage: false)
        
        self.intensitySlider.isEnabled = true
        self.intensityLabel.text = "Intensity"
        
        switch self.nameOfFilter {
        case "Red":
            self.intensitySlider.minimumValue = 1
            self.intensitySlider.maximumValue = 10
            self.intensitySlider.value = 5
        case "Green":
            self.intensitySlider.minimumValue = 1
            self.intensitySlider.maximumValue = 10
            self.intensitySlider.value = 5
        case "Blue":
            self.intensitySlider.minimumValue = 1
            self.intensitySlider.maximumValue = 10
            self.intensitySlider.value = 5
        case "Yellow":
            self.intensitySlider.minimumValue = 1
            self.intensitySlider.maximumValue = 10
            self.intensitySlider.value = 5
        case "Purple":
            self.intensitySlider.minimumValue = 1
            self.intensitySlider.maximumValue = 10
            self.intensitySlider.value = 5
        case "Brightness":
            self.intensitySlider.minimumValue = 0.1
            self.intensitySlider.maximumValue = 3
            self.intensitySlider.value = 2
        default:
            self.intensitySlider.minimumValue = 0
            self.intensitySlider.maximumValue = 1
            self.intensitySlider.value = 0.5
            self.intensityLabel.text = "Not available"
            self.intensitySlider.isEnabled = false
            break
        }
    }
    
    // MARK: called after filter to make the Original View disappear or shown after clicled the compare button
    func ChangeViews(originalImage: Bool) {
        UIView.animate(withDuration: 0.5){
            if (originalImage){
                self.OriginalimageView.alpha = 1
                self.overlay.alpha = 0.5
                self.intensityMenu.removeFromSuperview()
                self.editButton.isSelected = false
                self.editButton.isEnabled = false
            }else{
                self.OriginalimageView.alpha = 0
                self.overlay.alpha = 0
                self.editButton.isEnabled = true
            }
        }
    }
    
    // MARK: Slider Action... Change the intensity
    @IBAction func onChangeIntensity(_ sender: UISlider) {
        
        switch self.nameOfFilter {
        case "Red":
            let redFilter = RedFilter(intensity: Float(sender.value))
            redFilter.setBaseImage(image: self.originalImage)
            redFilter.apply()
            
            self.filteredImage = redFilter.toUIImage()
        case "Green":
            let greenFilter = GreenFilter(intensity: Float(sender.value))
            greenFilter.setBaseImage(image: self.originalImage)
            greenFilter.apply()
            
            self.filteredImage = greenFilter.toUIImage()
        case "Blue":
            let blueFilter = BlueFilter(intensity: Float(sender.value))
            blueFilter.setBaseImage(image: self.originalImage)
            blueFilter.apply()
            
            self.filteredImage = blueFilter.toUIImage()
        case "Yellow":
            let yellowFilter = YellowFilter(intensity: Float(sender.value))
            yellowFilter.setBaseImage(image: self.originalImage)
            yellowFilter.apply()
            
            self.filteredImage = yellowFilter.toUIImage()
        case "Purple":
            let purpleFilter = PurpleFilter(intensity: Float(sender.value))
            purpleFilter.setBaseImage(image: self.originalImage)
            purpleFilter.apply()
            
            self.filteredImage = purpleFilter.toUIImage()
        case "Brightness":
            let brightness = Brightness(intensity: Float(sender.value))
            brightness.setBaseImage(image: self.originalImage)
            brightness.apply()
            
            self.filteredImage = brightness.toUIImage()
        default:
            break
        }
        
        self.FilteredimageView.image = self.filteredImage
    }
    
    
    // MARK: Compare Button
    @IBAction func compare_action(_ sender: UIButton) {
        self.original = !self.original
        self.ChangeViews(originalImage: self.original)
    }
    

    
}


// From StackOverflow: http://stackoverflow.com/a/29138120
extension UIImage {
    func resizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
