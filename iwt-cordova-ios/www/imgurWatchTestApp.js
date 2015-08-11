(function(){
    "use strict";

    /**
     * @type {string}
     */
    var imgurClientId = '';

    /**
     * @type {number}
     */
    var pageNumber = 0;

    /**
     * @type {number}
     */
    var imageNumber = 0;

    /**
     * @type {Array}
     */
    var imageData = [];

    // forward declaration
    var getNextListOfImages;

    var loadNextImage = function() {
        if((imageData.length === 0) || (imageNumber >= imageData.length)) {
            getNextListOfImages();
            return;
        }

        var maxWidth = $(document).width() - 32;
        var maxHeight = $(document).height() - $('.iwtMaterialAppBar').height() - $('.iwtFooter').height() - 16;

        var thumbnailModifier = 'h';

        var heightScale = 1;
        var widthScale = 1;

        if(imageData[imageNumber].width > imageData[imageNumber].height) {
            heightScale = (imageData[imageNumber].height / imageData[imageNumber].width);
        } else {
            widthScale = (imageData[imageNumber].width / imageData[imageNumber].height);
        }

        if((maxWidth < (160*widthScale)) || (maxHeight < (160*heightScale))) {
            thumbnailModifier = 's';
        } else if((maxWidth < (320*widthScale)) || (maxHeight < (320*heightScale))) {
            thumbnailModifier = 't';
        } else if((maxWidth < (640*widthScale)) || (maxHeight < (640*heightScale))) {
            thumbnailModifier = 'm';
        } else if((maxWidth < (1024*widthScale)) || (maxHeight < (1024*heightScale))) {
            thumbnailModifier = 'l';
        }

        var imgSrc = 'http://i.imgur.com/' + imageData[imageNumber].id + thumbnailModifier + '.jpg';

        var mainImage = $('#iwtImage');
        mainImage.attr('src', imgSrc);
        mainImage.toggleClass('loading', true);

        $('#iwtImageLink').attr('href', 'http://i.imgur.com/' + imageData[imageNumber].id + '.jpg');

        imageNumber++;
    };

    var onGetRandomGalleryError = function() {
        alert('onGetRandomGalleryError');
    };

    var onGetRandomGallerySuccess = function(data) {
        imageData = $.grep(data.data, function(imageInfo) {
            return (!imageInfo.nsfw && !imageInfo.animated);
        });

        imageNumber = 0;

        loadNextImage();
    };

    getNextListOfImages = function() {
        $.ajax({
            url: 'https://api.imgur.com/3/gallery/r/earthporn/time/' + pageNumber,
            async: true,
            cache: false,
            dataType: 'json',
            beforeSend: function (xhr){
                xhr.setRequestHeader('Authorization', 'Client-ID ' + imgurClientId);
            },
            success: onGetRandomGallerySuccess,
            error: onGetRandomGalleryError
        });

        pageNumber++;
    };

    var informUserThereIsNoApiKey = function() {
        alert('No imgur api key, app will not work');
    };

    var onGetImgurApiKeyError = function() {
        informUserThereIsNoApiKey();
    };

    var onGetImgurApiKeySuccess = function(data) {
        imgurClientId = data.imgur_api_key_client_id;

        if((imgurClientId === undefined) || (imgurClientId.length === 0)) {
            informUserThereIsNoApiKey();
            return;
        }

        getNextListOfImages();
    };

    var getImgurApiKey = function() {
        $.ajax({
            url: 'settings.json',
            async: true,
            cache: false,
            dataType: 'json',
            success: onGetImgurApiKeySuccess,
            error: onGetImgurApiKeyError
        });
    };

    var onNextButtonClick = function() {
        loadNextImage();
    };

    var onShareButtonClick = function() {
        window.open('mailto:?subject=ImgurWatchTest&body=' + $('#iwtImageLink').attr('href'));
    };

    var onSendButtonClick = function() {
        alert('TODO: Send to watch...');
    };

    var onImageLoaded = function() {
        $('#iwtImage').toggleClass('loading', false);
    };

    var applyPseudoHover = function(e) {
        var target = $(e.target);

        if(!target.is('.iwtButton')) {
            target = target.parents('.iwtButton').eq(0);
        }

        target.toggleClass('pseudoHover', true);
        target.toggleClass('pseudoActive', false);
    };

    var applyPseudoActive = function(e) {
        var target = $(e.target);

        if(!target.is('.iwtButton')) {
            target = target.parents('.iwtButton').eq(0);
        }

        target.toggleClass('pseudoHover', false);
        target.toggleClass('pseudoActive', true);
    };

    var removePseudoHoverAndPseudoActive = function(e) {
        var target = $(e.target);

        if(!target.is('.iwtButton')) {
            target = target.parents('.iwtButton').eq(0);
        }

        target.toggleClass('pseudoHover', false);
        target.toggleClass('pseudoActive', false);
    };

    $(document).ready(function(){
        $('#nextButton').on('click', onNextButtonClick);
        $('#shareButton').on('click', onShareButtonClick);
        $('#sendButton').on('click', onSendButtonClick);

        var buttons = $('.iwtButton');

        buttons.on('touchstart mouseenter mouseover', applyPseudoHover);
        buttons.on('mousedown', applyPseudoActive);
        buttons.on('touchend touchcancel mouseleave mouseout mouseup', removePseudoHoverAndPseudoActive);


        var mainImage = $('#iwtImage');
        mainImage.on('load', onImageLoaded);
        mainImage.on('error', onImageLoaded);
        mainImage.on('abort', onImageLoaded);

        getImgurApiKey();
    });

})();
