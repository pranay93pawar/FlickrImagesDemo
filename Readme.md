FlickrImagesDemo
=====================================
FlickrImagesDemo is a project that uses the Flickr image search API and shows the results in a 3-column scrollable collection view.  

## Description:

* Enter queries such as "kittens"  in search bar to search images from Flickr.
* Use infinite scrolling to automatically requesting and displaying more images when the user scrolls to the bottom of the view.  
* Use Model-View-ViewModel (MVVM) Architecture.
* Use Image caching for the photos displayed in the app to save network and time.
* Use Storyboard Auto-layout.

## About Flickr API

To search images, API endpoint used is:

https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key={yourKey}&%20format=json&nojsoncallback=1&safe_search=1&text={yourSearchQuery}

Replace {yourSearchQuery} with search keyword.

Generate your api_key [here] (https://www.flickr.com/services/api/misc.api_keys.html)

More documentation about the search endpoint can be found [here] (https:// www.flickr.com/services/api/explore/flickr.photos.search)


It returns a JSON object with a list of Flickr photo models. Each Flickr photo model is defined as below:

```json
{
  "id": "23451156376",
  "owner": "28017113@N08",
  "secret": "8983a8ebc7",
  "server": "578",
  "farm": 1,
  "title": "Merry Christmas!",
  "ispublic": 1,
  "isfriend": 0,
  "isfamily": 0
}
```
To load the photo, you can build the full URL following this pattern:
http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg

Thus, using our Flickr photo model example above, the full URL would be:
https://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg
