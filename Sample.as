package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	import fl.controls.List;
	import fl.events.ListEvent;

	import net.nend.adobeair.InterstitialAd;
	import net.nend.adobeair.InterstitialAdEvent;
	import net.nend.adobeair.FullBoardAd;
	import net.nend.adobeair.InterstitialVideoAd;
	import net.nend.adobeair.RewardedVideoAd;
	import net.nend.adobeair.VideoAd;
	import net.nend.adobeair.BannerAd;
	import net.nend.adobeair.Position;
	import net.nend.adobeair.NativeAdLoader;
	import net.nend.adobeair.NativeAd;
	import net.nend.adobeair.RewardItem;
	import net.nend.adobeair.NativeAdEvent;
	import net.nend.adobeair.BannerAdEvent;
	import net.nend.adobeair.FullBoardAdEvent;
	import net.nend.adobeair.VideoAdEvent;
	import net.nend.adobeair.UserFeature;
	import net.nend.adobeair.Gender;

	public class Sample extends MovieClip {
		private var bannerAd: BannerAd;
		private var fullBoardAd: FullBoardAd;
		private var interstitialVideoAd: InterstitialVideoAd;
		private var rewardedVideoAd: RewardedVideoAd;
		private var nativeAdLoader: NativeAdLoader;
		private var nativeAd: NativeAd = null;
		private var currentPosition: int = 0;
		private var positions: Array = [
			Position.LEFT,
			Position.TOP,
			Position.RIGHT,
			Position.BOTTOM,
			Position.CENTER_HORIZONTAL,
			Position.CENTER_VERTICAL,
			Position.LEFT | Position.TOP,
			Position.LEFT | Position.BOTTOM,
			Position.RIGHT | Position.TOP,
			Position.RIGHT | Position.BOTTOM,
			Position.CENTER_HORIZONTAL | Position.TOP,
			Position.CENTER_HORIZONTAL | Position.BOTTOM,
			Position.CENTER_VERTICAL | Position.LEFT,
			Position.CENTER_VERTICAL | Position.RIGHT,
			Position.CENTER_HORIZONTAL | Position.CENTER_VERTICAL
		];

		public function Sample() {
			log("start");
			// constructor code
			list.rowHeight = 100;
			list.addEventListener(ListEvent.ITEM_CLICK, clickListItem);

			// banner
			if (isAndroid()) {
				bannerAd = new BannerAd("3174", "c5cb8bc474345961c6e7a9778c947957ed8e1e4f", true);
			} else {
				bannerAd = new BannerAd("3172", "a6eca9dd074372c898dd1df549301f277c53f2b9", true);
			}
			bannerAd.addEventListener(BannerAdEvent.COMPLETE, handleBannerAdEvent);
			bannerAd.addEventListener(BannerAdEvent.ERROR, handleBannerAdEvent);
			bannerAd.addEventListener(BannerAdEvent.CLICK, handleBannerAdEvent);
			bannerAd.addEventListener(BannerAdEvent.OPTOUT, handleBannerAdEvent);
			bannerAd.position = positions[currentPosition++];
			bannerAd.isOutputLog = true;

			list.addItem({
				label: "LoadBannerAd",
				func: function (): void {
					bannerAd.loadAd();
				}
			});
			list.addItem({
				label: "HideBannerAd",
				func: function (): void {
					bannerAd.hideAd();
				}
			});
			list.addItem({
				label: "ShowBannerAd",
				func: function (): void {
					bannerAd.showAd();
				}
			});
			list.addItem({
				label: "PauseBannerAd",
				func: function (): void {
					bannerAd.pause();
				}
			});
			list.addItem({
				label: "ResumeBannerAd",
				func: function (): void {
					bannerAd.resume();
				}
			});
			list.addItem({
				label: "PositioningBannerAd",
				func: function (): void {
					if (currentPosition == positions.length) {
						currentPosition = 0;
					}
					bannerAd.position = positions[currentPosition++];
				}
			});
			list.addItem({
				label: "DisposeBannerAd",
				func: function (): void {
					bannerAd.dispose();
				}
			});

			// interstitial
			InterstitialAd.shared.addEventListener(InterstitialAdEvent.COMPLETED, handleInterstitialAdEvent);
			InterstitialAd.shared.addEventListener(InterstitialAdEvent.ERROR, handleInterstitialAdEvent);
			InterstitialAd.shared.addEventListener(InterstitialAdEvent.DOWNLOAD, handleInterstitialAdEvent);
			InterstitialAd.shared.addEventListener(InterstitialAdEvent.CLOSE, handleInterstitialAdEvent);
			InterstitialAd.shared.addEventListener(InterstitialAdEvent.OPTOUT, handleInterstitialAdEvent);
			InterstitialAd.shared.isAutoReloadEnabled = false;
			InterstitialAd.shared.isOutputLog = true;

			list.addItem({
				label: "LoadInterstitialAd",
				func: function (): void {
					if (isAndroid()) {
						InterstitialAd.shared.loadAd("213206", "8c278673ac6f676dae60a1f56d16dad122e23516");
					} else {
						InterstitialAd.shared.loadAd("213208", "308c2499c75c4a192f03c02b2fcebd16dcb45cc9");
					}
				}
			});
			list.addItem({
				label: "ShowInterstitialAd",
				func: function (): void {
					var ret: uint = InterstitialAd.shared.showAd();
					log("Result: " + ret);
				}
			});
			list.addItem({
				label: "ShowInterstitialAdWithSpot",
				func: function (): void {
					if (isAndroid()) {
						InterstitialAd.shared.showAd("213206");
					} else {
						InterstitialAd.shared.showAd("213208");
					}
				}
			});
			list.addItem({
				label: "DismissInterstitialAd",
				func: function (): void {
					var timer: Timer = new Timer(5000, 1);
					timer.addEventListener(TimerEvent.TIMER, onTick);
					timer.start();
				}
			});

			// native
			if (isAndroid()) {
				nativeAdLoader = new NativeAdLoader("485520", "a88c0bcaa2646c4ef8b2b656fd38d6785762f2ff");
			} else {
				nativeAdLoader = new NativeAdLoader("485507", "31e861edb574cfa0fb676ebdf0a0b9a0621e19fc");
			}
			nativeAdLoader.addEventListener(NativeAdEvent.COMPLETE, handleNativeAdEvent);
			nativeAdLoader.addEventListener(NativeAdEvent.ERROR, handleNativeAdEvent);
			nativeAdLoader.isOutputLog = true;

			list.addItem({
				label: "LoadNativeAd",
				func: function (): void {
					nativeAdLoader.loadAd();
				}
			});
			list.addItem({
				label: "AutoReloadNativeAd",
				func: function (): void {
					nativeAdLoader.enableAutoReload(30);
				}
			});
			list.addItem({
				label: "StopAutoReloadNativeAd",
				func: function (): void {
					nativeAdLoader.disableAutoReload();
				}
			});
			list.addItem({
				label: "ImpressionNativeAd",
				func: function (): void {
					if (nativeAd != null) {
						nativeAd.trackImpression();
					}
				}
			});
			list.addItem({
				label: "ClickNativeAd",
				func: function (): void {
					if (nativeAd != null) {
						nativeAd.adClick();
					}
				}
			});
			list.addItem({
				label: "ClickNativeAdInformation",
				func: function (): void {
					if (nativeAd != null) {
						nativeAd.informationClick();
					}
				}
			});
			list.addItem({
				label: "DisposeNativeAd",
				func: function (): void {
					nativeAdLoader.dispose();
				}
			});

			// fullBoard
			if (isAndroid()) {
				fullBoardAd = new FullBoardAd("485520", "a88c0bcaa2646c4ef8b2b656fd38d6785762f2ff");
			} else {
				fullBoardAd = new FullBoardAd("485504", "30fda4b3386e793a14b27bedb4dcd29f03d638e5");
			}
			fullBoardAd.setBackgroundColor(1.0, 0.0, 0.0, 1.0);
			fullBoardAd.addEventListener(FullBoardAdEvent.COMPLETE, handleFullBoardAdEvent);
			fullBoardAd.addEventListener(FullBoardAdEvent.ERROR, handleFullBoardAdEvent);
			fullBoardAd.addEventListener(FullBoardAdEvent.SHOW, handleFullBoardAdEvent);
			fullBoardAd.addEventListener(FullBoardAdEvent.CLOSE, handleFullBoardAdEvent);
			fullBoardAd.addEventListener(FullBoardAdEvent.CLICK, handleFullBoardAdEvent);

			list.addItem({
				label: "LoadFullBoardAd",
				func: function (): void {
					fullBoardAd.loadAd();
				}
			});
			list.addItem({
				label: "ShowFullBoardAd",
				func: function (): void {
					fullBoardAd.showAd();
				}
			});
			list.addItem({
				label: "DisposeFullBoardAd",
				func: function (): void {
					fullBoardAd.dispose();
				}
			});

			// InterstitialVideo
			if (isAndroid()) {
				interstitialVideoAd = new InterstitialVideoAd("802559", "e9527a2ac8d1f39a667dfe0f7c169513b090ad44");
				interstitialVideoAd.addFallbackFullBoard("485520", "a88c0bcaa2646c4ef8b2b656fd38d6785762f2ff");
			} else {
				interstitialVideoAd = new InterstitialVideoAd("802557", "b6a97b05dd088b67f68fe6f155fb3091f302b48b");
				interstitialVideoAd.addFallbackFullBoard("485504", "30fda4b3386e793a14b27bedb4dcd29f03d638e5");
			}
			interstitialVideoAd.addEventListener(VideoAdEvent.COMPLETE, handleVideoAdEvent);
			interstitialVideoAd.addEventListener(VideoAdEvent.ERROR, handleVideoAdEvent);
			interstitialVideoAd.addEventListener(VideoAdEvent.SHOW, handleVideoAdEvent);
			interstitialVideoAd.addEventListener(VideoAdEvent.CLOSE, handleVideoAdEvent);
			interstitialVideoAd.addEventListener(VideoAdEvent.VIDEO_START, handleVideoAdEvent);
			interstitialVideoAd.addEventListener(VideoAdEvent.VIDEO_STOP, handleVideoAdEvent);
			interstitialVideoAd.addEventListener(VideoAdEvent.VIDEO_COMPLETE, handleVideoAdEvent);
			interstitialVideoAd.addEventListener(VideoAdEvent.VIDEO_ERROR, handleVideoAdEvent);
			interstitialVideoAd.addEventListener(VideoAdEvent.CLICK, handleVideoAdEvent);
			interstitialVideoAd.addEventListener(VideoAdEvent.OPTOUT, handleVideoAdEvent);
			interstitialVideoAd.userId = "interstitialVideoAd-userId";
			interstitialVideoAd.isOutputLog = true;

			list.addItem({
				label: "LoadInterstitialVideoAd",
				func: function (): void {
					interstitialVideoAd.loadAd();
				}
			});
			list.addItem({
				label: "IsReadyInterstitialVideoAd",
				func: function (): void {
					log("isReady: " + interstitialVideoAd.isReady);
				}
			});
			list.addItem({
				label: "ShowInterstitialVideoAd",
				func: function (): void {
					interstitialVideoAd.showAd();
				}
			});
			list.addItem({
				label: " DisposeInterstitialVideoAd",
				func: function (): void {
					interstitialVideoAd.dispose();
				}
			});

			// RewardedVideo
			if (isAndroid()) {
				rewardedVideoAd = new RewardedVideoAd("802558", "a6eb8828d64c70630fd6737bd266756c5c7d48aa");
			} else {
				rewardedVideoAd = new RewardedVideoAd("802555", "ca80ed7018734d16787dbda24c9edd26c84c15b8");
			}
			rewardedVideoAd.addEventListener(VideoAdEvent.COMPLETE, handleVideoAdEvent);
			rewardedVideoAd.addEventListener(VideoAdEvent.ERROR, handleVideoAdEvent);
			rewardedVideoAd.addEventListener(VideoAdEvent.SHOW, handleVideoAdEvent);
			rewardedVideoAd.addEventListener(VideoAdEvent.CLOSE, handleVideoAdEvent);
			rewardedVideoAd.addEventListener(VideoAdEvent.VIDEO_START, handleVideoAdEvent);
			rewardedVideoAd.addEventListener(VideoAdEvent.VIDEO_STOP, handleVideoAdEvent);
			rewardedVideoAd.addEventListener(VideoAdEvent.VIDEO_COMPLETE, handleVideoAdEvent);
			rewardedVideoAd.addEventListener(VideoAdEvent.VIDEO_ERROR, handleVideoAdEvent);
			rewardedVideoAd.addEventListener(VideoAdEvent.CLICK, handleVideoAdEvent);
			rewardedVideoAd.addEventListener(VideoAdEvent.OPTOUT, handleVideoAdEvent);
			rewardedVideoAd.addEventListener(VideoAdEvent.REWARDED, handleVideoAdEvent);
			rewardedVideoAd.userId = "rewardedVideoAd-userId";
			rewardedVideoAd.isOutputLog = true;

			list.addItem({
				label: "LoadRewardedVideoAd",
				func: function (): void {
					rewardedVideoAd.loadAd();
				}
			});
			list.addItem({
				label: "IsReadyRewardedVideoAd",
				func: function (): void {
					log("isReady: " + rewardedVideoAd.isReady);
				}
			});
			list.addItem({
				label: "ShowRewardedVideoAd",
				func: function (): void {
					rewardedVideoAd.showAd();
				}
			});
			list.addItem({
				label: " DisposeRewardedVideoAd",
				func: function (): void {
					rewardedVideoAd.dispose();
				}
			});

			list.addItem({
				label: " SetVideoAdUserFeature",
				func: function (): void {
					var feature: UserFeature = new UserFeature();
					feature.gender = Gender.MALE;
					feature.age = 20;
					feature.setBirthday(1998, 2, 7);
					feature.addCustomFeature("someString", "test");
					feature.addCustomFeature("someBoolean", true);
					feature.addCustomFeature("someInterger1", 100);
					feature.addCustomFeature("someInterger2", -1);
					feature.addCustomFeature("someNumber", 123.45);
					interstitialVideoAd.userFeature = feature;
					rewardedVideoAd.userFeature = feature;

				}
			});
		}

		private static function isAndroid(): Boolean {
			return (Capabilities.version.substr(0, 3) == "AND");
		}

		private static function isIOS(): Boolean {
			return (Capabilities.version.substr(0, 3) == "IOS");
		}

		private function clickListItem(event: ListEvent): void {
			var func: Function = event.item.func;
			func();
		}

		private function log(text: String): void {
			trace("[nend-AdobeAir-Sample] " + text);
		}

		private function handleBannerAdEvent(event: BannerAdEvent): void {
			log("BannerAdEvent: " + event.type + ", errorCode: " + event.errorCode);
		}

		private function handleInterstitialAdEvent(event: InterstitialAdEvent): void {
			log("InterstitialAdEvent: " + event.type + ", spot: " + event.spotId + ", errorCode: " + event.errorCode);
		}

		private function handleNativeAdEvent(event: NativeAdEvent): void {
			log("NativeAdEvent: " + event.type + ", errorCode: " + event.errorCode);
			if (event.ad != null) {
				nativeAd = event.ad;
				log("title: " + nativeAd.title);
				log("content: " + nativeAd.content);
				log("promotionUrl: " + nativeAd.promotionUrl);
				log("promotionName: " + nativeAd.promotionName);
				log("actionText: " + nativeAd.actionText);
				log("imageUrl: " + nativeAd.imageUrl);
				log("logoUrl: " + nativeAd.logoUrl);
			}
		}

		private function handleFullBoardAdEvent(event: FullBoardAdEvent): void {
			log("FullBoardAdEvent: " + event.type + ", errorCode: " + event.errorCode);
		}

		private function handleVideoAdEvent(event: VideoAdEvent): void {
			log("VideoAdEvent: " + event.type + ", errorCode: " + event.errorCode);
			if (event.rewardItem != null) {
				var item: RewardItem = event.rewardItem;
				log("currency name: " + item.name + ", amount: " + item.amount);
			}
		}

		private function onTick(event: TimerEvent): void {
			InterstitialAd.shared.dismissAd();
		}
	}
}