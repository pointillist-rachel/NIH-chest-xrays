library(tidyverse)
library(tensorflow)
library(keras)
library(tfdatasets)



# preprocessed_data_ints.csv feature map:
feature_map <- list(
  'No Finding' = tf$io$FixedLenFeature(shape(), tf$int32, default_value = None),
  'Atelectasis' = tf$io$FixedLenFeature(shape(), tf$int32, default_value = None),
  'Consolidation' = tf$io$FixedLenFeature(shape(), tf$int32, default_value = None),
  'Infiltration' = tf$io$FixedLenFeature(shape(), tf$int32, default_value = None),
  'Pneumothorax' = tf$io$FixedLenFeature(shape(), tf$int32, default_value = None),
  'Edema'  = tf$io$FixedLenFeature(shape(), tf$int32, default_value = None),
  'Emphysema' = tf$io$FixedLenFeature(shape(), tf$int32, default_value = None),
  'Fibrosis' = tf$io$FixedLenFeature(shape(), tf$int32, default_value = None),
  'Effusion' = tf$io$FixedLenFeature(shape(), tf$int32, default_value = None),
  'Pneumonia' = tf$io$FixedLenFeature(shape(), tf$int32, default_value = None),
  'Pleural_Thickening' = tf$io$FixedLenFeature(shape(), tf$int32, default_value = None),
  'Cardiomegaly' = tf$io$FixedLenFeature(shape(), tf$int32, default_value = None),
  'Nodule' = tf$io$FixedLenFeature(shape(), tf$int32, default_value = None),
  'Mass' = tf$io$FixedLenFeature(shape(), tf$int32, default_value = None),
  'Hernia' = tf$io$FixedLenFeature(shape(), tf$int32, default_value = None),
  'image' = tf$io$FixedLenFeature(shape(), tf$string, default_value = None)
)

# List of 256 .TFREC files in data folder
image_dir <- file.path(".", "R", "NIH chest data", "data")
image_files <- list.files(path = image_dir,
                          full.names = TRUE)

# Divide into training, validation, and test sets
split1 <- floor(length(image_files)*0.8)
split2 <- floor(length(image_files)*0.9)

train <- image_files[1:split1]
val <- image_files[(split1 + 1): split2]
test <- image_files[(split2 + 1):length(image_files)]

print(paste0("Train TFREC files: ", length(train)))
print(paste0("Validation TFREC files: ", length(val)))
print(paste0("Test TFREC files: ", length(test)))
length(train) + length(val) + length(test) == length(image_files)


get_img_data <- function(filenames) {   #train, val, or test; tfrec files
  a <- tfrecord_dataset(filenames) %>%  #should inc. all records, all tfrecs
    dataset_map(function(single_image){ #map to each one:
      example <- tf$io$parse_single_example(example, feature_map)
      image <- tf$io$decode_jpeg(example['image'], channels = 3) %>% #thought there was only one channel?
        image_array_resize(150, 150, "channels_last") %>%
        tf$cast(tf$int)/255
    })
} 




### preprocessed_data.csv

# TFDatasets can't understand tf.bools, so we convert to ints first:
responses_ints <- read_csv(file.path(".", "R", "NIH chest data", "preprocessed_data.csv"))
responses_ints <- responses_ints %>% modify_if(is.logical, as.integer)
write_csv(responses_ints, file.path(".", "R", "NIH chest data", "preprocessed_data_ints.csv"))


responses <- make_csv_dataset(
  file.path(".", "R", "NIH chest data", "preprocessed_data_ints.csv"),
  batch_size = 5,
  column_names = c('image','No Finding', 'Atelectasis',
                   'Consolidation', 'Infiltration', 'Pneumothorax',
                   'Edema', 'Emphysema', 'Fibrosis', 'Effusion',
                   'Pneumonia', 'Pleural_Thickening', 'Cardiomegaly',
                   'Nodule', 'Mass', 'Hernia'),
  column_defaults = c(tf$string, tf$int32, tf$int32, tf$int32,
                      tf$int32, tf$int32, tf$int32, tf$int32,
                      tf$int32, tf$int32, tf$int32, tf$int32,
                      tf$int32, tf$int32, tf$int32, tf$int32),
  field_delim = ",",
  header = TRUE,
  num_epochs = 1
)

responses %>% 
  reticulate::as_iterator() %>%
  reticulate::iter_next() %>%
  reticulate::py_to_r()





