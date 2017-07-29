int numberOfSamples = 100;
int numberOfClusters = 5;

Sample samples[] = new Sample[numberOfSamples];
Float sampleProbs[] = new Float[numberOfSamples]; // probability distribution
ArrayList<Centroid> centroids;
Button nextButton;

Integer colors[] = {#CDDC39, #84FFFF, #EF5350, #FFC400, #EA80FC};
int step = 1;

void setup() {
  size(1280, 720);
  smooth();
  frameRate(30);

  // button init
  nextButton = new Button(1280 - 150, 720 - 80, 130, 60);

  // samples init
  for (int i = 0; i < numberOfSamples; i++) {
    samples[i] = new Sample(random(0, width), random(0, height));
  }

  // centroids init
  centroids = new ArrayList<Centroid>();
}


void draw() {
  background(38, 50, 56);

  fill(#F50057);
  noStroke();
  nextButton.show();

  if (step == 1) {
    noStroke();
    showSamples();
    noLoop();
  } else if (step == 2) {
    noStroke();
    showSamples();

    chooseFirstCentroid();
    stroke(255);
    strokeWeight(3);
    showCentroids();
    noLoop();
  } else if (step == 3) {
    noStroke();
    initClusters();
    computeProbs();
    showClusteredSamplesWithProbs();
    showClusteredLinesWithProbs();

    stroke(255);
    strokeWeight(3);
    showCentroids();
  } else if (step % 2 == 0 && centroids.size() != numberOfClusters) {
    noStroke();
    predictClusters();
    computeProbs();
    chooseCentroid();
    showClusteredSamplesWithProbs();
    showClusteredLinesWithProbs();

    stroke(255);
    strokeWeight(3);
    showCentroids();
    noLoop();
  } else if (step % 2 == 1 && centroids.size() != numberOfClusters) {
    noStroke();
    predictClusters();
    computeProbs();

    showClusteredSamplesWithProbs();
    showClusteredLinesWithProbs();
    stroke(255);
    strokeWeight(3);
    showCentroids();
    noLoop();
  } else if (step - numberOfClusters * 2 == 1) {
    noStroke();
    showSamples();

    stroke(255);
    strokeWeight(3);
    showCentroids();
    noLoop();
  } else if (step - numberOfClusters * 2 == 2) {
    noStroke();
    predictClusters();
    showClusteredSamples();
    showClusteredLines();

    stroke(255);
    strokeWeight(3);
    showCentroids();
    noLoop();
  } else if ((step - numberOfClusters * 2) % 2 == 1) {
    noStroke();
    showClusteredSamples();
    showClusteredLines();

    stroke(255);
    strokeWeight(3);
    updateCentroids();
    showCentroids();
  } else if ((step - numberOfClusters * 2) % 2 == 0) {
    noStroke();
    predictClusters();
    showClusteredSamples();
    showClusteredLines();

    stroke(255);
    strokeWeight(3);
    showCentroids();
    noLoop();
  }
}

void mouseClicked() {
  if (nextButton.isMouseOnButton()) {
    // if clicked while centroids are moving,
    // update centroids position
    step++;

    loop();
  }
}

void showSamples() {
  for (int i = 0; i < numberOfSamples; i++) {
    fill(colors[samples[i].cluster]);
    fill(255);
    samples[i].show();
  }
}

void showClusteredSamples() {
  for (int i = 0; i < numberOfSamples; i++) {
    fill(colors[samples[i].cluster]);
    samples[i].show();
  }
}

void showClusteredSamplesWithProbs() {
  for (int i = 0; i < numberOfSamples; i++) {
    // exponentate to make clear difference
    // closer to a centroid, more transparent
    float alpha = 255.0 * pow(samples[i].prob, 0.5/float(numberOfClusters));
    fill(colors[samples[i].cluster], alpha);
    
    samples[i].show();
  }
}

void showCentroids() {
  for (int i = 0; i < centroids.size(); i++) {
    fill(colors[centroids.get(i).cluster]);
    centroids.get(i).show();
  }
}

void chooseFirstCentroid() {
  // choose which sample is as a centroid
  // uniform distribution
  int sampleIndex = floor(random(0, numberOfSamples));

  centroids.add(new Centroid(samples[sampleIndex].x, samples[sampleIndex].y, 0));
  samples[sampleIndex].isCentroid = true;
}

void chooseCentroid() {
  // choose which sample is as a centroid
  // closer to a centroid, higher probability
  FloatList probs = new FloatList();
  int centroidIndexOnProbs = 0;
  
  for (int i = 0; i < samples.length; i++) {
    if (!samples[i].isCentroid) {
      probs.append(samples[i].prob);
    }
  }

  // append 0 to head of probs
  probs.reverse();
  probs.append(0.0);
  probs.reverse();

  for (int i = 1; i < probs.size(); i++) {
    probs.add(i, probs.get(i - 1));
  }

  float centroidGenerator = random(0, probs.get(probs.size() - 1));
  for (int i = 0; i < probs.size() - 1; i++) {
    if (probs.get(i) < centroidGenerator
      && centroidGenerator <= probs.get(i + 1)) {
      centroidIndexOnProbs = i;
      break;
    }
  }

  int centroidIndex = centroidIndexOnProbs;
  for (int i = 0; i <= centroidIndexOnProbs; i++) {
    if(samples[i].isCentroid) {
      centroidIndex++;
    }
  }

  int cluster = centroids.size();
  centroids.add(new Centroid(samples[centroidIndex].x, samples[centroidIndex].y, cluster));
  samples[centroidIndex].isCentroid = true;
}
void initClusters() {
  for (int i = 0; i < numberOfSamples; i++) {
    samples[i].cluster = 0;
  }
}

void predictClusters() {
  for (int i = 0; i < numberOfSamples; i++) {
    float sed[] = new float[centroids.size()];
    for (int j = 0; j < centroids.size(); j++) {
      sed[j] = squaredEuclideanDistance(samples[i].x, samples[i].y,
                                        centroids.get(j).x,
                                        centroids.get(j).y);
    }
    samples[i].cluster = argmin(sed);
  }
}

int argmin(float[] arr) {
  for (int i = 0; i < arr.length; i++) {
    if (arr[i] == min(arr)) {
      return i;
    }
  }
  return 0;
}

void showClusteredLines() {
  for (int i = 0; i < numberOfSamples; i++) {
    float centroidX = centroids.get(samples[i].cluster).x;
    float centroidY = centroids.get(samples[i].cluster).y;

    stroke(colors[samples[i].cluster]);
    strokeWeight(2);
    line(samples[i].x, samples[i].y, centroidX, centroidY);
  }
}

void showClusteredLinesWithProbs() {
  for (int i = 0; i < numberOfSamples; i++) {
    float centroidX = centroids.get(samples[i].cluster).x;
    float centroidY = centroids.get(samples[i].cluster).y;

    // exponentate to make clear difference
    // closer to a centroid, more transparent
    float alpha = 255.0 * pow(samples[i].prob, 0.5/float(numberOfClusters));
    stroke(colors[samples[i].cluster], alpha);
    strokeWeight(2);
    line(samples[i].x, samples[i].y, centroidX, centroidY);
  }
}

void updateCentroids() {
  Float xMeans[] = new Float[numberOfClusters];
  Float yMeans[] = new Float[numberOfClusters];
  Float elementsCount[] = new Float[numberOfClusters];

  // init arrays
  for (int i = 0; i < xMeans.length; i++) {
    xMeans[i] = 0.0;
    yMeans[i] = 0.0;
    elementsCount[i] = 0.0;
  }

  // compute center of each cluster
  for (int i = 0; i < numberOfSamples; i++) {
    xMeans[samples[i].cluster] += samples[i].x;
    yMeans[samples[i].cluster] += samples[i].y;
    elementsCount[samples[i].cluster]++;
  }

  for (int i = 0; i < xMeans.length; i++) {
    xMeans[i] /= elementsCount[i];
    yMeans[i] /= elementsCount[i];
  }

  for (int i = 0; i < centroids.size(); i++) {
    centroids.get(i).moveTo(xMeans[i], yMeans[i]);
  }
}

void computeProbs() {
  float sse; // sum of squared error between each sample and centroids
  sse = 0.0;

  for (int i = 0; i < numberOfSamples; i++) {
    if (!samples[i].isCentroid) {
      float sed = squaredEuclideanDistance(samples[i].x, samples[i].y,
                                          centroids.get(samples[i].cluster).x,
                                          centroids.get(samples[i].cluster).y);
      
      sse += sed;
    }
  }

  for (int i = 0; i < numberOfSamples; i++) {
    if (!samples[i].isCentroid) {
      float sed = squaredEuclideanDistance(samples[i].x, samples[i].y,
                                          centroids.get(samples[i].cluster).x,
                                          centroids.get(samples[i].cluster).y);

      samples[i].prob = sed / sse;
    } else {
      samples[i].prob = 0.0;
    }
  }
}

float squaredEuclideanDistance(float x1, float y1, float x2, float y2) {
  float residualX = x1 - x2;
  float residualY = y1 - y2;
  
  return pow(residualX, 2) + pow(residualY, 2);
}
