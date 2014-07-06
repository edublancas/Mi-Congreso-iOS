//
//  EBCongresistaDetailViewController.m
//  MiCongreso
//

//  Copyright (c) 2013 Eduardo Blancas https://github.com/edublancas
//
//  MIT LICENSE
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

#import "EBCongresistaDetailViewController.h"

@interface EBCongresistaDetailViewController ()

@end

@implementation EBCongresistaDetailViewController

@synthesize congresista;


-(void)didUpdateDetails{
    /*if (congresista.tipo==kSenador) {
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 4)];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 2)];
        [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }*/
    [self downloadImage];
    [self.tableView reloadData];
}

-(void)downloadImage{
    NSLog(@"Descargando imagen...");
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:congresista.imagen] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (data){
            UIImage *image;
            
            if (congresista.tipo==kSenador) {
                image = [UIImage imageWithData:data];
            }else{
                image = [UIImage imageWithData:data scale:1.5f];
            }
            
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.layer.cornerRadius = 5.0f;
            imageView.layer.masksToBounds = YES;
            self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 150)];
            
            
            [self.tableView.tableHeaderView setBackgroundColor:[UIColor clearColor]];
            imageView.center = self.tableView.tableHeaderView.center;
            [self.tableView.tableHeaderView addSubview:imageView];
            
            /*NSInteger sections = [self numberOfSectionsInTableView:self.tableView];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, sections)];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];*/
            [self.tableView reloadData];
        }
        else if (error)
            NSLog(@"%@",error);
    }];
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Detalles";
    
    congresista.delegate = self;
    NSLog(@"Descargando detalles... %@", congresista.detallesString);

    [congresista descargarDetalles];
    
    //NSLog(@"Detalles: %@", congresista.detallesString);
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewDidDisappear:(BOOL)animated{
    congresista.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (!congresista.detallesDisponibles) {
        return 3;
    }else{
        if (congresista.tipo == kSenador) {
            return 7;
        }else{
            return 5;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.numberOfLines = 1;
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = congresista.nombre;
            break;
        case 1:
            cell.textLabel.text = congresista.partido;
            break;
        case 2:
            cell.textLabel.text = congresista.estado;
            break;
        case 3:
            cell.textLabel.text = congresista.email;
            break;
        case 4:
            cell.textLabel.text = congresista.suplente;
            break;
        case 5:
            cell.textLabel.numberOfLines = 4;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            cell.textLabel.adjustsFontSizeToFitWidth = NO;
            cell.textLabel.text = congresista.direccion;
            break;
        case 6:
            cell.textLabel.text = [[congresista.telefono componentsSeparatedByString:@"Ext:"]objectAtIndex:0];
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	if (section==0) {
        return @"Pulse para conocer más";
    }else if (section==6) {
        return [NSString stringWithFormat:@"Ext: %@", [[congresista.telefono componentsSeparatedByString:@"Ext:"]objectAtIndex:1]];
    }else{
        return @"";
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Nombre";
        case 1:
            return @"Partido";
        case 2:
            return @"Estado";
        case 3:
            return @"Email";
        case 4:
            return @"Suplente";
        case 5:
            return @"Dirección";
        case 6:
            return @"Teléfono";
        default:
            return @"";
            break;
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        
        NSString *string = [NSString stringWithFormat:
                            @"https://www.google.com/search?q=%@", congresista.nombre];
        NSString *encodedQuery =  [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:encodedQuery];
        
        
        EBBrowserViewController *b = [[EBBrowserViewController alloc]initWithTitle:congresista.nombre andURL:url];
        
        [self.navigationController pushViewController:b animated:YES];
        
    }else if (indexPath.section==3) {
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil)
        {
            // We must always check whether the current device is configured for sending emails
            if ([mailClass canSendMail])
            {
                [self displayComposerSheet];
            }
            else
            {
                [self launchMailAppOnDevice];
            }
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }else if(indexPath.section==6){
        NSString *urlString = [NSString stringWithFormat:@"tel://%@", [[congresista.telefono componentsSeparatedByString:@"Ext:"]objectAtIndex:0]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==5) {
        return 44.0f*2;
    }else{
        return 44.0f;
    }
}

-(void)launchMailAppOnDevice
{
	NSString *recipients = [NSString stringWithFormat:@"mailto:%@", congresista.email];
	NSString *body = @"&body=\n\n\nEnviado desde Mi Congreso para iOS";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

-(void)displayComposerSheet{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
    
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:congresista.email];
	
	[picker setToRecipients:toRecipients];

	
	// Fill out the email body text
	NSString *emailBody = @"\n\n\nEnviado desde Mi Congreso para iOS";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentViewController:picker animated:YES completion:nil];
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{

	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
