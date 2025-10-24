const swiperOffer = new Swiper('#swiper-offer', {
	speed: 1000,
	direction: 'vertical',
	autoHeight: true,
	autoplay : {
		delay: 5000,
	},
	pagination: {
		el: '.swiper-pagination',
		clickable: true,
	},
});

const swiperFAQ = new Swiper('#swiper-faq', {
	direction: 'horizontal',
	spaceBetween: 20,
	breakpoints: {
		100: {
			slidesPerView: 1,
			//slidesPerGroup: 1
		},
		481: {
			slidesPerView: 2,
			//slidesPerGroup: 2
		},
		1001: {
			slidesPerView: 3,
			//slidesPerGroup: 3
		}
	},
	pagination: {
		el: '.faq-swiper-pagination',
		clickable: true,
	}
})

function hamburger() {
	var menu = document.getElementsByClassName("hamburger-menu");
	if (menu[0].style.display === "none") {
		menu[0].style.display = "flex";
	} else {
		menu[0].style.display = "none";
	}
}

function servicesDropdown() {
	var menu = document.getElementsByClassName("services-menu");
	if (menu[0].style.display === "none") {
		menu[0].style.display = "flex";
	} else {
		menu[0].style.display = "none";
	}
}

// Screen width tweeks
const wccHeadlineTitle = document.getElementById("wcc-headline-title");
const wccHeadlineTitleTextOld = "WHY CHOOSE CYPRUS?";
const wccHeadlineTitleTextNew = "Why Choose Cyprus?";

const mapHeadlineParagraph = document.getElementById("map-headline-paragraph");
const mapHeadlineParagraphDesktop = "Click your mouse over any city to learn more about it";
const mapHeadlineParagraphMobile = "Tap on any city to learn more about it";

const wwaAboutUs = document.getElementById("wwa-about-us");
const wwaLine = document.getElementById("wwa-line");

const hmhTitle = document.getElementById("hmh-title");
const hmhTitleTextWide = "HOW WE MAKE IT HAPPEN";
const hmhTitleTextThin = "HOW WE MAKE" + "\n" + "IT HAPPEN";

const footerCopyright = document.getElementById("footer-copyright");
const footerCopyrightTextWide = "&copy; 2022 PAM Consulting. All rights reserved | <a>Disclaimer</a> | <a>Privacy policy</a>";
const footerCopyrightTextThin = "&copy; 2022 PAM Consulting. All rights reserved<br><a>Disclaimer</a> | <a>Privacy policy</a>";
const footerCopyrightTextThinner = "&copy; 2022 PAM Consulting. All rights reserved<br><a>Disclaimer</a><br><a>Privacy policy</a>";

function wwaLineOffset() {
	wwaLine.style.marginLeft = String(-wwaAboutUs.getBoundingClientRect().left) + "px";
}

wwaLineOffset();

function widthAdapt() {
	const width = window.innerWidth;

	//var FAQVisibleSlides = document.querySelectorAll('#swiper-faq .swiper-slide-faq-fully-visible');
	//var FAQNumberOfVisibleSlides = FAQVisibleSlides.length;
	//swiperFAQ.params.slidesPerGroup = FAQNumberOfVisibleSlides;
	//swiperFAQ.update();

	if (width >= 1000) {
		mapHeadlineParagraph.textContent = mapHeadlineParagraphDesktop;
	} else {
		mapHeadlineParagraph.textContent = mapHeadlineParagraphMobile;
	}

	if (width > 768) {
		footerCopyright.innerHTML = footerCopyrightTextWide;
	} else if (width <= 768 && width > 480) {
		footerCopyright.innerHTML = footerCopyrightTextThin;
	} else {
		footerCopyright.innerHTML = footerCopyrightTextThinner;
	}

	if (width <= 480) {
		wccHeadlineTitle.textContent = wccHeadlineTitleTextNew;
		hmhTitle.innerText = hmhTitleTextThin;
		window.removeEventListener('resize', wwaLineOffset);
		wwaLine.style.marginLeft = "0px";
	} else {
		wccHeadlineTitle.textContent = wccHeadlineTitleTextOld;
		hmhTitle.innerText = hmhTitleTextWide;
		window.addEventListener('resize', wwaLineOffset);
	}
}

widthAdapt();

window.addEventListener('resize', widthAdapt);

// Cyprus Map
const nicosiaMap = document.getElementById("nicosia-map");
const limassolMap = document.getElementById("limassol-map");

const nicosiaMapLabel = document.getElementById("nicosia-map-label");
const limassolMapLabel = document.getElementById("limassol-map-label");

var mapDescriptionCardNicosia = document.getElementById("map-description-card-nicosia");
var mapDescriptionCardLimassol = document.getElementById("map-description-card-limassol");

var cards = [];
cards.push(mapDescriptionCardNicosia);
cards.push(mapDescriptionCardLimassol);

function hideCityCards() {
	cards.forEach((card) => card.style.display = "none");
}

function cyprusMapClickHandler(city) {
	switch (city) {
		case "Limassol": {
			if (window.getComputedStyle(mapDescriptionCardLimassol).display === "none") {
				console.log("Showing Limassol card");
				hideCityCards();
				mapDescriptionCardLimassol.style.display = "flex";
				break;
			} else {
				console.log("Limassol card already visible");
				break;
			}
		}
		case "Nicosia": {
			if (window.getComputedStyle(mapDescriptionCardNicosia).display === "none") {
				console.log("Showing Nicosia card");
				hideCityCards();
				mapDescriptionCardNicosia.style.display = "flex";
				break;
			} else {
				console.log("Nicosia card already visible");
				break;
			}
		}
		default: {
			alert("Something went very wrong!!!");
			break;
		}
	}
}

nicosiaMap.addEventListener('click', event => {cyprusMapClickHandler("Nicosia")});
limassolMap.addEventListener('click', event => {cyprusMapClickHandler("Limassol")});

nicosiaMapLabel.addEventListener('click', event => {cyprusMapClickHandler("Nicosia")});
limassolMapLabel.addEventListener('click', event => {cyprusMapClickHandler("Limassol")});

